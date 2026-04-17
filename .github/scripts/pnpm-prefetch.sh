#!/usr/bin/env bash

# ==========================================================
# SCRIPT: pnpm-prefetch.sh
# PURPOSE: Prefetch dependencies into pnpm store (no install)
# USE CASES:
#   - Speed up CI installs via cache
#   - Prepare offline install layer
# CONTEXT:
#   - Used in CI (GitHub Actions) and local (act/dev)
# VERSION: v1.1.0
# ==========================================================


set -euo pipefail

echo "[pnpm-fetch] Prefetching dependencies..."

command -v pnpm >/dev/null || {
  echo "❌ pnpm is not installed"
  exit 1
}

pnpm fetch

echo "[pnpm-fetch] Done"

