#!/usr/bin/env bash

# ==========================================================
# SCRIPT: pnpm-store-path.sh
# PURPOSE: Retrieve pnpm global store path
# USE CASES:
#   - Used for caching pnpm store in CI
# CONTEXT:
#   - Outputs to GITHUB_OUTPUT or stdout (local)
# VERSION: v1.1.0
# ==========================================================


set -euo pipefail

echo "[pnpm store-path] Getting pnpm store path..."

command -v pnpm >/dev/null || {
  echo "❌ pnpm is not installed"
  exit 1
}


STORE_PATH="$(pnpm store path)"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "STORE_PATH=$STORE_PATH" >> "$GITHUB_OUTPUT"
else
  echo "[pnpm-store] Local path: $STORE_PATH"
fi

echo "[pnpm-store] Done"