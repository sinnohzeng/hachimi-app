import { BigQuery } from "@google-cloud/bigquery";
import { GoogleAuth } from "google-auth-library";
import { Octokit } from "@octokit/rest";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import {
  CallableRequest,
  HttpsError,
  onCall,
} from "firebase-functions/v2/https";
import { onSchedule } from "firebase-functions/v2/scheduler";
import {
  defineInt,
  defineSecret,
  defineString,
} from "firebase-functions/params";
import jwt from "jsonwebtoken";

admin.initializeApp();

const db = admin.firestore();
const bigQuery = new BigQuery();
const googleAuth = new GoogleAuth({
  scopes: ["https://www.googleapis.com/auth/cloud-platform"],
});

const DEFAULT_TRIAGE_MODEL = "gemini-2.5-flash";
const DEFAULT_VERTEX_LOCATION = "us-central1";

const obsDatasetParam = defineString("OBS_DATASET", { default: "obs" });
const bqLocationParam = defineString("BQ_LOCATION", { default: "US" });
const triageLimitParam = defineInt("AI_DEBUG_TRIAGE_LIMIT", { default: 25 });
const aiUsageThresholdParam = defineInt("AI_USAGE_THRESHOLD", { default: 1000000 });
const triageModelParam = defineString("TRIAGE_MODEL", { default: DEFAULT_TRIAGE_MODEL });
const vertexLocationParam = defineString("TRIAGE_VERTEX_LOCATION", {
  default: DEFAULT_VERTEX_LOCATION,
});
const githubAppIdParam = defineString("GITHUB_APP_ID", { default: "" });
const githubAppInstallationIdParam = defineString("GITHUB_APP_INSTALLATION_ID", {
  default: "",
});
const githubRepoParam = defineString("AI_DEBUG_GITHUB_REPO", { default: "" });
const githubAppPrivateKey = defineSecret("GITHUB_APP_PRIVATE_KEY");

const PROMPT_VERSION = "v2";

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
  return handleDeleteAccount(request, "deleteAccountV1", false);
});

export const wipeUserDataV1 = onCall(async (request) => {
  return handleWipeUserData(request, "wipeUserDataV1", false);
});

export const deleteAccountV2 = onCall(
  {
    enforceAppCheck: true,
    consumeAppCheckToken: true,
  },
  async (request) => {
    return handleDeleteAccount(request, "deleteAccountV2", true);
  },
);

export const wipeUserDataV2 = onCall(
  {
    enforceAppCheck: true,
    consumeAppCheckToken: true,
  },
  async (request) => {
    return handleWipeUserData(request, "wipeUserDataV2", true);
  },
);

export const monitorAiUsageV1 = onSchedule(
  { schedule: "0 6 * * *" },
  async () => {
    const projectId = process.env.GCLOUD_PROJECT;
    if (!projectId) {
      logger.warn("monitorAiUsageV1: GCLOUD_PROJECT not set");
      return;
    }

    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);
    const dateStr = yesterday.toISOString().slice(0, 10).replace(/-/g, "");

    const query = `
      SELECT
        COALESCE(SUM(CAST(ep.value.int_value AS INT64)), 0) AS total_tokens,
        COUNT(DISTINCT user_pseudo_id) AS unique_users,
        COUNTIF(
          (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'operation') = 'diary'
        ) AS diary_count,
        COUNTIF(
          (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'operation') = 'chat'
        ) AS chat_count
      FROM \`${projectId}.analytics_${obsDatasetParam.value()}.events_${dateStr}\`,
        UNNEST(event_params) AS ep
      WHERE event_name = 'ai_token_usage'
        AND ep.key IN ('prompt_tokens', 'completion_tokens')
    `;

    try {
      const [rows] = await bigQuery.query({
        query,
        location: bqLocationParam.value(),
      });
      const row = rows[0] || { total_tokens: 0, unique_users: 0, diary_count: 0, chat_count: 0 };
      const totalTokens = Number(row.total_tokens ?? 0);
      const uniqueUsers = Number(row.unique_users ?? 0);
      const diaryCount = Number(row.diary_count ?? 0);
      const chatCount = Number(row.chat_count ?? 0);

      await db.doc(`admin/ai_usage_daily/${dateStr}`).set({
        date: dateStr,
        totalTokens,
        uniqueUsers,
        diaryCount,
        chatCount,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      logger.info("ai_usage_monitor_completed", {
        date: dateStr,
        totalTokens,
        uniqueUsers,
        diaryCount,
        chatCount,
      });

      if (totalTokens > aiUsageThresholdParam.value()) {
        logger.warn("ai_usage_threshold_exceeded", {
          date: dateStr,
          totalTokens,
          threshold: aiUsageThresholdParam.value(),
        });
      }
    } catch (error) {
      logger.error("ai_usage_monitor_failed", {
        date: dateStr,
        error_code: mapErrorCode(error),
      });
    }
  },
);

export const runAiDebugTriageV2 = onSchedule(
  {
    schedule: "every 15 minutes",
    secrets: [githubAppPrivateKey],
  },
  async () => {
    const functionName = "runAiDebugTriageV2";
    const startedAt = Date.now();
    const traceId = `triage_${Date.now()}`;

    logger.info("ai_debug_triage_started", {
      function_name: functionName,
      trace_id: traceId,
      result: "running",
      error_code: null,
    });

    const tasks = await loadAiDebugTasks();
    if (tasks.length === 0) {
      logger.info("ai_debug_triage_no_tasks", {
        function_name: functionName,
        trace_id: traceId,
        latency_ms: Date.now() - startedAt,
        result: "success",
        error_code: null,
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
      error_code: null,
    });
  },
);

async function handleDeleteAccount(
  request: CallableRequest<unknown>,
  functionName: string,
  enforceReplayProtection: boolean,
): Promise<CallableTelemetryResponse> {
  const startedAt = Date.now();
  const uid = requireAuthUid(request.auth?.uid);
  const context = requireOperationContext(request.data);

  rejectConsumedAppCheckToken(request, enforceReplayProtection);
  logCallStart(functionName, context, request.app?.alreadyConsumed === true);

  try {
    await deleteUserData(uid);
    await deleteAuthUser(uid);
    const response = buildSuccessResponse(functionName, context, startedAt);
    logger.info("account_lifecycle_call_success", {
      ...baseFields(functionName, context),
      latency_ms: response.latency_ms,
      result: response.result,
      error_code: null,
      app_check_consumed: request.app?.alreadyConsumed === true,
    });
    return response;
  } catch (error) {
    const errorCode = mapErrorCode(error);
    logger.error("account_lifecycle_call_failed", {
      ...baseFields(functionName, context),
      latency_ms: Date.now() - startedAt,
      result: "failure",
      error_code: errorCode,
      app_check_consumed: request.app?.alreadyConsumed === true,
    });
    throw wrapHttpsError(error, errorCode, `${functionName} failed`);
  }
}

async function handleWipeUserData(
  request: CallableRequest<unknown>,
  functionName: string,
  enforceReplayProtection: boolean,
): Promise<CallableTelemetryResponse> {
  const startedAt = Date.now();
  const uid = requireAuthUid(request.auth?.uid);
  const context = requireOperationContext(request.data);

  rejectConsumedAppCheckToken(request, enforceReplayProtection);
  logCallStart(functionName, context, request.app?.alreadyConsumed === true);

  try {
    await deleteUserData(uid);
    const response = buildSuccessResponse(functionName, context, startedAt);
    logger.info("account_lifecycle_call_success", {
      ...baseFields(functionName, context),
      latency_ms: response.latency_ms,
      result: response.result,
      error_code: null,
      app_check_consumed: request.app?.alreadyConsumed === true,
    });
    return response;
  } catch (error) {
    const errorCode = mapErrorCode(error);
    logger.error("account_lifecycle_call_failed", {
      ...baseFields(functionName, context),
      latency_ms: Date.now() - startedAt,
      result: "failure",
      error_code: errorCode,
      app_check_consumed: request.app?.alreadyConsumed === true,
    });
    throw wrapHttpsError(error, errorCode, `${functionName} failed`);
  }
}

function rejectConsumedAppCheckToken(
  request: CallableRequest<unknown>,
  enforceReplayProtection: boolean,
): void {
  if (!enforceReplayProtection) return;
  if (request.app?.alreadyConsumed === true) {
    throw new HttpsError(
      "permission-denied",
      "App Check token replay detected. Please retry with a fresh token.",
    );
  }
}

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
  if (typeof value !== "string" || value.trim().length === 0) {
    throw new HttpsError("invalid-argument", `Missing string field: ${key}`);
  }
  return value;
}

function readNumber(data: Record<string, unknown>, key: string): number {
  const value = data[key];
  if (typeof value === "number") return value;
  if (typeof value === "string" && value.trim().length > 0) {
    const parsed = Number(value);
    if (!Number.isNaN(parsed)) return parsed;
  }
  throw new HttpsError("invalid-argument", `Missing number field: ${key}`);
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
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

function logCallStart(
  functionName: string,
  context: OperationContext,
  alreadyConsumed: boolean,
): void {
  logger.info("account_lifecycle_call_started", {
    ...baseFields(functionName, context),
    latency_ms: 0,
    result: "running",
    error_code: null,
    app_check_consumed: alreadyConsumed,
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
  return maybeCode === 5 || maybeCode === "not-found";
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
  return error.code === "auth/user-not-found";
}

function mapErrorCode(error: unknown): string {
  if (error instanceof HttpsError) return error.code;
  if (isRecord(error) && typeof error.code === "string") return error.code;
  return "unknown_error";
}

function wrapHttpsError(
  error: unknown,
  errorCode: string,
  fallbackMessage: string,
): HttpsError {
  if (error instanceof HttpsError) return error;
  const message =
    isRecord(error) && typeof error.message === "string"
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
    FROM \`${projectId}.${obsDatasetParam.value()}.ai_debug_tasks_v1\`
    ORDER BY velocity_24h DESC
    LIMIT @limit
  `;

  const [rows] = await bigQuery.query({
    query,
    location: bqLocationParam.value(),
    params: { limit: triageLimitParam.value() },
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
  const aiReport = await generateReportWithVertex(task);
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

async function generateReportWithVertex(task: AiDebugTask): Promise<
  Pick<
    AiDebugReport,
    | "root_cause_hypothesis"
    | "repro_steps"
    | "affected_scope"
    | "fix_suggestion"
    | "model_name"
  >
> {
  const projectId = process.env.GCLOUD_PROJECT;
  if (!projectId) return buildHeuristicReport(task);

  const modelName = readConfiguredString(
    triageModelParam.value(),
    DEFAULT_TRIAGE_MODEL,
  );
  const location = readConfiguredString(
    vertexLocationParam.value(),
    DEFAULT_VERTEX_LOCATION,
  );
  const accessToken = await getAccessToken();
  if (!accessToken) return buildHeuristicReport(task);

  const prompt = [
    "You are an SRE assistant.",
    "Given issue telemetry, return strict JSON with keys:",
    "root_cause_hypothesis, repro_steps, affected_scope, fix_suggestion.",
    "Do not include markdown fences.",
    "Telemetry:",
    JSON.stringify(task),
  ].join("\n");

  const endpoint =
    `https://${location}-aiplatform.googleapis.com/v1/projects/${projectId}/` +
    `locations/${location}/publishers/google/models/${modelName}:generateContent`;

  try {
    const response = await fetch(endpoint, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        contents: [{ role: "user", parts: [{ text: prompt }] }],
        generationConfig: {
          temperature: 0.2,
          maxOutputTokens: 600,
          responseMimeType: "application/json",
        },
      }),
    });

    if (!response.ok) return buildHeuristicReport(task);

    const body = await response.json();
    const text = extractVertexText(body);
    if (!text) return buildHeuristicReport(task);

    const parsed = parseAiJson(text);
    if (!parsed) return buildHeuristicReport(task);

    return {
      root_cause_hypothesis: parsed.root_cause_hypothesis,
      repro_steps: parsed.repro_steps,
      affected_scope: parsed.affected_scope,
      fix_suggestion: parsed.fix_suggestion,
      model_name: modelName,
    };
  } catch {
    return buildHeuristicReport(task);
  }
}

function extractVertexText(body: unknown): string | undefined {
  if (!isRecord(body)) return undefined;
  const candidates = body.candidates;
  if (!Array.isArray(candidates) || candidates.length === 0) return undefined;
  const first = candidates[0];
  if (!isRecord(first)) return undefined;
  const content = first.content;
  if (!isRecord(content)) return undefined;
  const parts = content.parts;
  if (!Array.isArray(parts) || parts.length === 0) return undefined;

  const text = parts
    .filter(isRecord)
    .map((part) => (typeof part.text === "string" ? part.text : ""))
    .join("");
  return text.trim().length > 0 ? text : undefined;
}

function parseAiJson(raw: string): {
  root_cause_hypothesis: string;
  repro_steps: string;
  affected_scope: string;
  fix_suggestion: string;
} | null {
  const cleaned = raw
    .trim()
    .replace(/^```json\s*/i, "")
    .replace(/^```\s*/i, "")
    .replace(/```$/i, "");

  try {
    const parsed = JSON.parse(cleaned);
    if (!isRecord(parsed)) return null;

    const hypothesis = parsed.root_cause_hypothesis;
    const reproSteps = parsed.repro_steps;
    const affectedScope = parsed.affected_scope;
    const fixSuggestion = parsed.fix_suggestion;

    if (
      typeof hypothesis !== "string" ||
      typeof reproSteps !== "string" ||
      typeof affectedScope !== "string" ||
      typeof fixSuggestion !== "string"
    ) {
      return null;
    }

    return {
      root_cause_hypothesis: hypothesis,
      repro_steps: reproSteps,
      affected_scope: affectedScope,
      fix_suggestion: fixSuggestion,
    };
  } catch {
    return null;
  }
}

async function getAccessToken(): Promise<string | undefined> {
  const client = await googleAuth.getClient();
  const token = await client.getAccessToken();
  if (typeof token === "string") return token;
  if (token && typeof token.token === "string") return token.token;
  return undefined;
}

function buildHeuristicReport(task: AiDebugTask): Pick<
  AiDebugReport,
  | "root_cause_hypothesis"
  | "repro_steps"
  | "affected_scope"
  | "fix_suggestion"
  | "model_name"
> {
  const modelName = readConfiguredString(
    triageModelParam.value(),
    DEFAULT_TRIAGE_MODEL,
  );
  return {
    root_cause_hypothesis:
      `Issue ${task.issue_id} likely comes from unchecked runtime inputs in ` +
      `${task.feature} with error_code=${task.error_code}.`,
    repro_steps:
      "1) Use the latest production build. " +
      `2) Navigate to ${task.feature}. ` +
      "3) Repeat the failing operation and inspect stack trace.",
    affected_scope:
      `Velocity=${task.velocity_24h}/24h, impacted_users=${task.impacted_users}. ` +
      "Likely user-visible in high-traffic path.",
    fix_suggestion:
      "Add defensive guards, validate preconditions, improve retry/error handling, " +
      "and ship regression tests for the failing code path.",
    model_name: `heuristic:${modelName}`,
  };
}

function readConfiguredString(value: string, fallback: string): string {
  const normalized = value.trim();
  return normalized.length > 0 ? normalized : fallback;
}

async function persistAiDebugReport(report: AiDebugReport): Promise<void> {
  const table = bigQuery
    .dataset(obsDatasetParam.value())
    .table("ai_debug_reports_v1");

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

async function createGithubDraftIssue(
  report: AiDebugReport,
): Promise<string | undefined> {
  const repository = githubRepoParam.value();
  const appId = githubAppIdParam.value();
  const installationId = githubAppInstallationIdParam.value();

  if (!repository || !appId || !installationId) return undefined;

  const parts = repository.split("/");
  if (parts.length !== 2) return undefined;
  const owner = parts[0];
  const repo = parts[1];

  const privateKey = githubAppPrivateKey.value();
  if (!privateKey) return undefined;

  const token = await createGitHubInstallationToken(
    appId,
    installationId,
    privateKey,
  );
  if (!token) return undefined;

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
      "- auth_mode: github_app",
    ].join("\n"),
    labels: ["ai-debug", "draft"],
  });

  return issue.data.html_url;
}

async function createGitHubInstallationToken(
  appId: string,
  installationId: string,
  privateKey: string,
): Promise<string | undefined> {
  const appJwt = buildGitHubAppJwt(appId, privateKey);
  const response = await fetch(
    `https://api.github.com/app/installations/${installationId}/access_tokens`,
    {
      method: "POST",
      headers: {
        Accept: "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        Authorization: `Bearer ${appJwt}`,
      },
    },
  );

  if (!response.ok) {
    logger.error("github_app_token_issue_failed", {
      status: response.status,
      result: "failure",
      error_code: "github_app_token_failed",
    });
    return undefined;
  }

  const body = await response.json();
  if (!isRecord(body)) return undefined;
  return typeof body.token === "string" ? body.token : undefined;
}

function buildGitHubAppJwt(appId: string, privateKey: string): string {
  const now = Math.floor(Date.now() / 1000);
  const normalized = privateKey.includes("\\n")
    ? privateKey.replace(/\\n/g, "\n")
    : privateKey;

  return jwt.sign(
    {
      iss: appId,
      iat: now - 60,
      exp: now + 540,
    },
    normalized,
    { algorithm: "RS256" },
  );
}

export const __test__ = {
  isAuthUserNotFound,
  isFirestoreNotFound,
  requireAuthUid,
  requireOperationContext,
  buildHeuristicReport,
  parseAiJson,
  buildGitHubAppJwt,
};
