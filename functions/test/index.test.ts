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

  it("handles idempotent auth-user-not-found", () => {
    assert.equal(__test__.isAuthUserNotFound({ code: "auth/user-not-found" }), true);
    assert.equal(__test__.isAuthUserNotFound({ code: "auth/internal" }), false);
  });

  it("handles idempotent firestore-not-found", () => {
    assert.equal(__test__.isFirestoreNotFound({ code: 5 }), true);
    assert.equal(__test__.isFirestoreNotFound({ code: "not-found" }), true);
    assert.equal(__test__.isFirestoreNotFound({ code: "permission-denied" }), false);
  });
});
