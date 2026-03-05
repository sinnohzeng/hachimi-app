import { BigQuery } from "@google-cloud/bigquery";
import { Octokit } from "@octokit/rest";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { onSchedule } from "firebase-functions/v2/scheduler";

admin.initializeApp();

const db = admin.firestore();
const bigQuery = new BigQuery();

const OBS_DATASET = process.env.OBS_DATASET ?? "obs";
const TRIAGE_LIMIT = Number(process.env.AI_DEBUG_TRIAGE_LIMIT ?? "25");
const TRIAGE_LOCATION = process.env.BQ_LOCATION ?? "US";
const TRIAGE_MODEL_NAME = process.env.AI_DEBUG_MODEL_NAME ?? "heuristic-v1";
const PROMPT_VERSION = "v1";

type OperationContext = {
  correlation_id: string;
  uid_hash: string;
  operation_stage: string;
  retry_count: number;
};

type CallableTelemetryResponse = {
  ok: boolean;
  correlation_id: string;
  function_name: string;
  latency_ms: number;
  result: "success";
  error_code?: string;
};

type AiDebugTask = {
  issue_id: string;
  feature: string;
  error_code: string;
  velocity_24h: number;
  impacted_users: number;
  sample_error: string;
  sample_stack: string;
  first_seen: string;
};

type AiDebugReport = {
  issue_id: string;
  root_cause_hypothesis: string;
  repro_steps: string;
  affected_scope: string;
  fix_suggestion: string;
  model_name: string;
  prompt_version: string;
  decision_trace_id: string;
  created_at: string;
  github_issue_url?: string;
};

export const deleteAccountV1 = onCall(async (request) => {
  const startedAt = Date.now();
  const functionName = "deleteAccountV1";
  const uid = requireAuthUid(request.auth?.uid);
  const context = requireOperationContext(request.data);

  logCallStart(functionName, context);

  try {
    await deleteUserData(uid);
    await deleteAuthUser(uid);
    const response = buildSuccessResponse(functionName, context, startedAt);
    logger.info("account_lifecycle_call_success", {
      ...baseFields(functionName, context),
      latency_ms: response.latency_ms,
      result: response.result,
      error_code: null,
    });
    return response;
  } catch (error) {
    const errorCode = mapErrorCode(error);
    logger.error("account_lifecycle_call_failed", {
      ...baseFields(functionName, context),
      latency_ms: Date.now() - startedAt,
      result: "failure",
      error_code: errorCode,
    });
    throw wrapHttpsError(error, errorCode, "deleteAccountV1 failed");
  }
});

export const wipeUserDataV1 = onCall(async (request) => {
  const startedAt = Date.now();
  const functionName = "wipeUserDataV1";
  const uid = requireAuthUid(request.auth?.uid);
  const context = requireOperationContext(request.data);

  logCallStart(functionName, context);

  try {
    await deleteUserData(uid);
    const response = buildSuccessResponse(functionName, context, startedAt);
    logger.info("account_lifecycle_call_success", {
      ...baseFields(functionName, context),
      latency_ms: response.latency_ms,
      result: response.result,
      error_code: null,
    });
    return response;
  } catch (error) {
    const errorCode = mapErrorCode(error);
    logger.error("account_lifecycle_call_failed", {
      ...baseFields(functionName, context),
      latency_ms: Date.now() - startedAt,
      result: "failure",
      error_code: errorCode,
    });
    throw wrapHttpsError(error, errorCode, "wipeUserDataV1 failed");
  }
});

export const runAiDebugTriageV1 = onSchedule("every 15 minutes", async () => {
  const functionName = "runAiDebugTriageV1";
  const startedAt = Date.now();
  const traceId = `triage_${Date.now()}`;

  logger.info("ai_debug_triage_started", {
    function_name: functionName,
    trace_id: traceId,
    result: "running",
  });

  const tasks = await loadAiDebugTasks();
  if (tasks.length == 0) {
    logger.info("ai_debug_triage_no_tasks", {
      function_name: functionName,
      trace_id: traceId,
      latency_ms: Date.now() - startedAt,
      result: "success",
    });
    return;
  }

  let createdReports = 0;
  for (const task of tasks) {
    const decisionTraceId = `${traceId}_${task.issue_id}`;
    try {
      const report = await createAiDebugReport(task, decisionTraceId);
      const issueUrl = await createGithubDraftIssue(report);
      await persistAiDebugReport({ ...report, github_issue_url: issueUrl });
      createdReports += 1;
    } catch (error) {
      logger.error("ai_debug_triage_task_failed", {
        function_name: functionName,
        trace_id: traceId,
        issue_id: task.issue_id,
        result: "failure",
        error_code: mapErrorCode(error),
      });
    }
  }

  logger.info("ai_debug_triage_completed", {
    function_name: functionName,
    trace_id: traceId,
    reports_created: createdReports,
    tasks_total: tasks.length,
    latency_ms: Date.now() - startedAt,
    result: "success",
  });
});

function requireAuthUid(uid: string | undefined): string {
  if (!uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }
  return uid;
}

function requireOperationContext(data: unknown): OperationContext {
  if (!isRecord(data)) {
    throw new HttpsError("invalid-argument", "Missing operation context.");
  }
  const correlationId = readString(data, "correlation_id");
  const uidHash = readString(data, "uid_hash");
  const operationStage = readString(data, "operation_stage");
  const retryCount = readNumber(data, "retry_count");

  return {
    correlation_id: correlationId,
    uid_hash: uidHash,
    operation_stage: operationStage,
    retry_count: retryCount,
  };
}

function readString(data: Record<string, unknown>, key: string): string {
  const value = data[key];
  if (typeof value != "string" || value.trim().length == 0) {
    throw new HttpsError("invalid-argument", `Missing string field: ${key}`);
  }
  return value;
}

function readNumber(data: Record<string, unknown>, key: string): number {
  const value = data[key];
  if (typeof value == "number") return value;
  if (typeof value == "string" && value.trim().length > 0) {
    const parsed = Number(value);
    if (!Number.isNaN(parsed)) return parsed;
  }
  throw new HttpsError("invalid-argument", `Missing number field: ${key}`);
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value == "object" && value != null;
}

function baseFields(functionName: string, context: OperationContext) {
  return {
    function_name: functionName,
    correlation_id: context.correlation_id,
    uid_hash: context.uid_hash,
    operation_stage: context.operation_stage,
    retry_count: context.retry_count,
  };
}

function logCallStart(functionName: string, context: OperationContext): void {
  logger.info("account_lifecycle_call_started", {
    ...baseFields(functionName, context),
    latency_ms: 0,
    result: "running",
    error_code: null,
  });
}

function buildSuccessResponse(
  functionName: string,
  context: OperationContext,
  startedAt: number,
): CallableTelemetryResponse {
  return {
    ok: true,
    correlation_id: context.correlation_id,
    function_name: functionName,
    latency_ms: Date.now() - startedAt,
    result: "success",
  };
}

async function deleteUserData(uid: string): Promise<void> {
  const userRef = db.collection("users").doc(uid);
  const snapshot = await userRef.get();
  if (!snapshot.exists) return;
  await deleteDocumentRecursively(userRef);
}

async function deleteDocumentRecursively(
  docRef: FirebaseFirestore.DocumentReference,
): Promise<void> {
  const collections = await docRef.listCollections();
  for (const collection of collections) {
    await deleteCollectionRecursively(collection);
  }
  await deleteDocument(docRef);
}

async function deleteCollectionRecursively(
  collection: FirebaseFirestore.CollectionReference,
): Promise<void> {
  const batchSize = 200;
  while (true) {
    const snapshot = await collection.limit(batchSize).get();
    if (snapshot.empty) return;
    for (const doc of snapshot.docs) {
      await deleteDocumentRecursively(doc.ref);
    }
  }
}

async function deleteDocument(
  docRef: FirebaseFirestore.DocumentReference,
): Promise<void> {
  try {
    await docRef.delete();
  } catch (error) {
    if (isFirestoreNotFound(error)) return;
    throw error;
  }
}

function isFirestoreNotFound(error: unknown): boolean {
  if (!isRecord(error)) return false;
  const maybeCode = error.code;
  return maybeCode == 5 || maybeCode == "not-found";
}

async function deleteAuthUser(uid: string): Promise<void> {
  try {
    await admin.auth().deleteUser(uid);
  } catch (error) {
    if (isAuthUserNotFound(error)) return;
    throw error;
  }
}

function isAuthUserNotFound(error: unknown): boolean {
  if (!isRecord(error)) return false;
  return error.code == "auth/user-not-found";
}

function mapErrorCode(error: unknown): string {
  if (error instanceof HttpsError) return error.code;
  if (isRecord(error) && typeof error.code == "string") return error.code;
  return "unknown_error";
}

function wrapHttpsError(
  error: unknown,
  errorCode: string,
  fallbackMessage: string,
): HttpsError {
  if (error instanceof HttpsError) return error;
  const message =
    isRecord(error) && typeof error.message == "string"
      ? error.message
      : fallbackMessage;
  return new HttpsError("internal", `${fallbackMessage} (${errorCode}): ${message}`);
}

async function loadAiDebugTasks(): Promise<AiDebugTask[]> {
  const projectId = process.env.GCLOUD_PROJECT;
  if (!projectId) return [];

  const query = `
    SELECT
      issue_id,
      feature,
      error_code,
      velocity_24h,
      impacted_users,
      sample_error,
      sample_stack,
      CAST(first_seen AS STRING) AS first_seen
    FROM \`${projectId}.${OBS_DATASET}.ai_debug_tasks_v1\`
    ORDER BY velocity_24h DESC
    LIMIT @limit
  `;

  const [rows] = await bigQuery.query({
    query,
    location: TRIAGE_LOCATION,
    params: { limit: TRIAGE_LIMIT },
  });

  return rows.map((row) => ({
    issue_id: String(row.issue_id ?? ""),
    feature: String(row.feature ?? "unknown"),
    error_code: String(row.error_code ?? "unknown_error"),
    velocity_24h: Number(row.velocity_24h ?? 0),
    impacted_users: Number(row.impacted_users ?? 0),
    sample_error: String(row.sample_error ?? ""),
    sample_stack: String(row.sample_stack ?? ""),
    first_seen: String(row.first_seen ?? ""),
  }));
}

async function createAiDebugReport(
  task: AiDebugTask,
  decisionTraceId: string,
): Promise<AiDebugReport> {
  const aiReport = await generateReportWithModel(task);
  return {
    issue_id: task.issue_id,
    root_cause_hypothesis: aiReport.root_cause_hypothesis,
    repro_steps: aiReport.repro_steps,
    affected_scope: aiReport.affected_scope,
    fix_suggestion: aiReport.fix_suggestion,
    model_name: aiReport.model_name,
    prompt_version: PROMPT_VERSION,
    decision_trace_id: decisionTraceId,
    created_at: new Date().toISOString(),
  };
}

async function generateReportWithModel(task: AiDebugTask): Promise<
  Pick<
    AiDebugReport,
    | "root_cause_hypothesis"
    | "repro_steps"
    | "affected_scope"
    | "fix_suggestion"
    | "model_name"
  >
> {
  const endpoint = process.env.AI_DEBUG_MODEL_ENDPOINT;
  const apiKey = process.env.AI_DEBUG_MODEL_API_KEY;
  if (!endpoint || !apiKey) {
    return buildHeuristicReport(task);
  }

  const payload = {
    issue: task,
    output_schema: {
      root_cause_hypothesis: "string",
      repro_steps: "string",
      affected_scope: "string",
      fix_suggestion: "string",
    },
  };

  try {
    const response = await fetch(endpoint, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      return buildHeuristicReport(task);
    }

    const body = await response.json();
    if (!isRecord(body)) return buildHeuristicReport(task);

    const hypothesis = typeof body.root_cause_hypothesis == "string"
      ? body.root_cause_hypothesis
      : "Likely runtime regression around the reported feature path.";
    const reproSteps = typeof body.repro_steps == "string"
      ? body.repro_steps
      : "1) Open affected flow 2) Execute recent failing operation 3) Observe error.";
    const affectedScope = typeof body.affected_scope == "string"
      ? body.affected_scope
      : "Impacts active users touching the affected feature path.";
    const fixSuggestion = typeof body.fix_suggestion == "string"
      ? body.fix_suggestion
      : "Add null guards, input validation, and targeted regression tests.";

    return {
      root_cause_hypothesis: hypothesis,
      repro_steps: reproSteps,
      affected_scope: affectedScope,
      fix_suggestion: fixSuggestion,
      model_name: TRIAGE_MODEL_NAME,
    };
  } catch {
    return buildHeuristicReport(task);
  }
}

function buildHeuristicReport(task: AiDebugTask): Pick<
  AiDebugReport,
  | "root_cause_hypothesis"
  | "repro_steps"
  | "affected_scope"
  | "fix_suggestion"
  | "model_name"
> {
  return {
    root_cause_hypothesis:
      `Issue ${task.issue_id} is likely caused by unchecked runtime inputs in ` +
      `${task.feature} with error_code=${task.error_code}.`,
    repro_steps:
      "1) Use the latest production build. " +
      `2) Navigate to ${task.feature}. ` +
      "3) Repeat the operation captured in telemetry and inspect stack trace.",
    affected_scope:
      `Velocity=${task.velocity_24h}/24h, impacted_users=${task.impacted_users}. ` +
      "Likely user-visible in high-traffic flow.",
    fix_suggestion:
      "Add defensive guards, validate preconditions, improve retry/error handling, " +
      "and ship regression tests covering the failing code path.",
    model_name: TRIAGE_MODEL_NAME,
  };
}

async function persistAiDebugReport(report: AiDebugReport): Promise<void> {
  const table = bigQuery.dataset(OBS_DATASET).table("ai_debug_reports_v1");
  await table.insert([
    {
      issue_id: report.issue_id,
      root_cause_hypothesis: report.root_cause_hypothesis,
      repro_steps: report.repro_steps,
      affected_scope: report.affected_scope,
      fix_suggestion: report.fix_suggestion,
      model_name: report.model_name,
      prompt_version: report.prompt_version,
      decision_trace_id: report.decision_trace_id,
      created_at: report.created_at,
      github_issue_url: report.github_issue_url ?? null,
    },
  ]);
}

async function createGithubDraftIssue(report: AiDebugReport): Promise<string | undefined> {
  const token = process.env.GITHUB_TOKEN;
  const repository =
    process.env.AI_DEBUG_GITHUB_REPO ?? process.env.GITHUB_REPOSITORY;
  if (!token || !repository) return undefined;

  const parts = repository.split("/");
  if (parts.length != 2) return undefined;
  const owner = parts[0];
  const repo = parts[1];

  const octokit = new Octokit({ auth: token });
  const issue = await octokit.issues.create({
    owner,
    repo,
    title: `[DRAFT][AI-DEBUG] ${report.issue_id}`,
    body: [
      "## Root Cause Hypothesis",
      report.root_cause_hypothesis,
      "",
      "## Repro Steps",
      report.repro_steps,
      "",
      "## Affected Scope",
      report.affected_scope,
      "",
      "## Fix Suggestion",
      report.fix_suggestion,
      "",
      `- model_name: ${report.model_name}`,
      `- prompt_version: ${report.prompt_version}`,
      `- decision_trace_id: ${report.decision_trace_id}`,
    ].join("\n"),
    labels: ["ai-debug", "draft"],
  });

  return issue.data.html_url;
}

export const __test__ = {
  isAuthUserNotFound,
  isFirestoreNotFound,
  requireAuthUid,
  requireOperationContext,
  buildHeuristicReport,
};
