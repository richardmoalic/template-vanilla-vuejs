#!/usr/bin/env bash

# ==========================================================
# SCRIPT: permissions-fix.sh
# PURPOSE: Normalize file permissions for CI containers
# USE CASES:
#   - Fix UID/GID mismatches (act, Docker, Playwright)
# CONTEXT:
#   - Avoids permission denied issues in CI
# VERSION: v1.1.0
# ==========================================================


set -euo pipefail

echo "[permissions-fix] Fixing permissions..."

chmod -R u+rwX ./ 2>/dev/null || true

echo "[permissions-fix] Done"

