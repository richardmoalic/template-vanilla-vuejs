#!/usr/bin/env bash

# ==========================================================
# SCRIPT: pnpm-install.sh
# PURPOSE: Install dependencies deterministically
# USE CASES:
#   - CI install step
#   - Local reproducible installs
# CONTEXT:
#   - Uses lockfile for strict reproducibility
# VERSION: v1.1.0
# ==========================================================


set -euo pipefail

echo "[pnpm-install] Installing dependencies..."

command -v pnpm >/dev/null || {
  echo "❌ pnpm is not installed"
  exit 1
}

pnpm install \
  --frozen-lockfile \
  --prefer-offline \
  --reporter=append-only

echo "[pnpm-install] Done"