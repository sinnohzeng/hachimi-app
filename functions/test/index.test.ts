import { strict as assert } from "node:assert";
import { describe, it } from "node:test";

import { __test__ } from "../src/index.js";

describe("account lifecycle helpers", () => {
  it("rejects unauthenticated calls", () => {
    assert.throws(() => __test__.requireAuthUid(undefined));
  });

  it("accepts authenticated uid", () => {
    assert.equal(__test__.requireAuthUid("u_1"), "u_1");
  });

  it("requires operation context fields", () => {
    const context = __test__.requireOperationContext({
      correlation_id: "corr_1",
      uid_hash: "hash_1",
      operation_stage: "account_deletion",
      retry_count: 2,
    });
    assert.equal(context.correlation_id, "corr_1");
    assert.equal(context.uid_hash, "hash_1");
    assert.equal(context.operation_stage, "account_deletion");
    assert.equal(context.retry_count, 2);
  });

  it("rejects missing operation context fields", () => {
    assert.throws(() => __test__.requireOperationContext({}));
  });

  it("handles idempotent auth-user-not-found", () => {
    assert.equal(__test__.isAuthUserNotFound({ code: "auth/user-not-found" }), true);
    assert.equal(__test__.isAuthUserNotFound({ code: "auth/internal" }), false);
  });

  it("handles idempotent firestore-not-found", () => {
    assert.equal(__test__.isFirestoreNotFound({ code: 5 }), true);
    assert.equal(__test__.isFirestoreNotFound({ code: "not-found" }), true);
    assert.equal(__test__.isFirestoreNotFound({ code: "permission-denied" }), false);
  });

  it("builds heuristic ai report", () => {
    const report = __test__.buildHeuristicReport({
      issue_id: "issue_1",
      feature: "sync",
      error_code: "network_error",
      velocity_24h: 12,
      impacted_users: 8,
      sample_error: "SocketException",
      sample_stack: "stack",
      first_seen: "2026-03-05",
    });
    assert.match(report.root_cause_hypothesis, /issue_1/);
    assert.equal(report.model_name, "heuristic:gemini-2.5-flash");
  });
});
