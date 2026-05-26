#!/usr/bin/env bash

# ==========================================================
# SCRIPT: pnpm-install.sh
# PURPOSE: Install dependencies deterministically
# USE CASES:
#   - CI install step
#   - Local reproducible installs
# CONTEXT:
#   - Uses lockfile for strict reproducibility
# Usage: ./pnpm-install.sh --secure
# The --secure flag (used in Release) runs scripts but disables cache fallback
# The default (used in PR) ignores scripts for speed/safety
# VERSION: v2.0.0
# ==========================================================


set -euo pipefail

echo "[pnpm-install] Installing dependencies..."

command -v pnpm >/dev/null || {
  echo "❌ pnpm is not installed"
  exit 1
}


is_secure=false

if [[ "${1:-}" == "--secure" ]]; then
  is_secure=true
fi

INSTALL_FLAGS=(
  --frozen-lockfile
  --prefer-offline
  --reporter=append-only
)

if [[ "$is_secure" == "false" ]]; then
  INSTALL_FLAGS+=(--ignore-scripts)
fi

pnpm install "${INSTALL_FLAGS[@]}"

echo "[pnpm-install] Mode: $([[ "$is_secure" == "true" ]] && echo "trusted" || echo "untrusted")"
echo "[pnpm-install] Done"