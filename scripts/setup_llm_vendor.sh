#!/bin/bash
# ---
# Setup llama_cpp_dart vendor dependency.
#
# pub.dev releases exclude the llama.cpp git submodule source,
# so we clone the full repo with pinned versions for reproducible builds.
#
# Usage: bash scripts/setup_llm_vendor.sh
# Re-setup: delete packages/ first, then re-run.
# ---

set -euo pipefail

VENDOR_DIR="packages/llama_cpp_dart"
REPO_URL="https://github.com/netdur/llama_cpp_dart.git"

# Pin exact versions — modify these to upgrade
# v0.2.3 release commit (tag not published, using commit hash)
LLAMA_DART_REF="22dd48a"
LLAMA_CPP_REF="0e4ebeb05796951fed7885763a73ada18b42e9ca"

if [ -f "$VENDOR_DIR/pubspec.yaml" ]; then
  echo "Vendor already set up at $VENDOR_DIR."
  echo "To re-setup, delete packages/ first."
  exit 0
fi

echo "==> Cloning llama_cpp_dart ($LLAMA_DART_REF)..."
mkdir -p packages
git clone --depth 50 "$REPO_URL" "$VENDOR_DIR"
cd "$VENDOR_DIR"
git checkout "$LLAMA_DART_REF"

echo "==> Initializing submodules (llama.cpp source)..."
git submodule update --init --recursive

echo "==> Pinning llama.cpp to $LLAMA_CPP_REF..."
cd src/llama.cpp
git checkout "$LLAMA_CPP_REF" 2>/dev/null || {
  # If shallow clone doesn't have the commit, fetch more history
  git fetch --depth 100 origin
  git checkout "$LLAMA_CPP_REF"
}

echo ""
echo "Vendor setup complete."
echo "  llama_cpp_dart: $LLAMA_DART_REF"
echo "  llama.cpp:      $LLAMA_CPP_REF"
