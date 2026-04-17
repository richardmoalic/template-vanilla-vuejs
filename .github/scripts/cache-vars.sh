#!/usr/bin/env bash

# ==========================================================
# SCRIPT: cache-vars.sh
# PURPOSE: Standardize cache + build environment variables
# USE CASES:
#   - Shared config across CI and local runs (act)
# CONTEXT:
#   - Handles ACT vs GitHub runner differences
# VERSION: v1.1.0
# ==========================================================


set -euo pipefail
# -------------------------------
# Workspace root
# -------------------------------
WORKSPACE_ROOT="${GITHUB_WORKSPACE:-$(pwd)}"

# -------------------------------
# Default cache root
# -------------------------------
DEFAULT_CACHE_ROOT="${DEFAULT_CACHE_ROOT:-$WORKSPACE_ROOT/cache}"


# Tool-specific caches
DEFAULT_VITE_CACHE="${DEFAULT_CACHE_ROOT}/vite_cache"
DEFAULT_VITEST_CACHE="${DEFAULT_CACHE_ROOT}/vitest_cache"
DEFAULT_PLAYWRIGHT_CACHE="${DEFAULT_CACHE_ROOT}/playwright_cache"
DEFAULT_PNPM_CACHE="${DEFAULT_CACHE_ROOT}/pnpm_store"

echo "[cache-vars] Setting environment variables..."

# Prefix: differentiate act vs CI
PREFIX=$([ "${ACT:-}" = "true" ] && echo "act" || echo "ci")

# Export environment variables
export CACHE_PREFIX="${PREFIX}-v1"
export VITE_CACHE_DIR="${VITE_CACHE_DIR:-$DEFAULT_VITE_CACHE}"
export VITEST_CACHE_DIR="${VITEST_CACHE_DIR:-$DEFAULT_VITEST_CACHE}"
export PLAYWRIGHT_CACHE_DIR="${PLAYWRIGHT_CACHE_DIR:-$DEFAULT_PLAYWRIGHT_CACHE}"
export PNPM_CACHE_DIR="${PNPM_CACHE_DIR:-$DEFAULT_PNPM_CACHE}"

# Export to GitHub environment if available
if [ -n "${GITHUB_ENV:-}" ]; then
  {
    echo "CACHE_PREFIX=$CACHE_PREFIX"
    echo "VITE_CACHE_DIR=$VITE_CACHE_DIR"
    echo "VITEST_CACHE_DIR=$VITEST_CACHE_DIR"
    echo "PLAYWRIGHT_CACHE_DIR=$PLAYWRIGHT_CACHE_DIR"
    echo "PNPM_CACHE_DIR=$PNPM_CACHE_DIR"
  } >> "$GITHUB_ENV"
fi

# Ensure directories exist
mkdir -p "$VITE_CACHE_DIR" "$VITEST_CACHE_DIR" "$PLAYWRIGHT_CACHE_DIR" "$PNPM_CACHE_DIR"

echo "[cache-vars] Mode: $PREFIX"
echo "[cache-vars] Vite: $VITE_CACHE_DIR"
echo "[cache-vars] Vitest: $VITEST_CACHE_DIR"
echo "[cache-vars] Playwright: $PLAYWRIGHT_CACHE_DIR"
echo "[cache-vars] pnpm: $PNPM_CACHE_DIR"