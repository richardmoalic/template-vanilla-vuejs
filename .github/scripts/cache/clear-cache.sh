#!/usr/bin/env bash
# ==========================================================
# SCRIPT: clear-cache.sh
# ==========================================================
set -euo pipefail


# Find relative path to tools dir
BASE_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../.."
TOOLS_DIR="$BASE_DIR/.github/tools"

CLEAR_CACHE_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$CLEAR_CACHE_SCRIPT_DIR/../lib/logger.env"

log_warn "cache" "Cleaning project toolchain..."

if [[ -d "$TOOLS_DIR" ]]; then
    # Security: Use :? to prevent rm -rf / if variable is empty
    rm -rf "${TOOLS_DIR:?}"/cache/*
    rm -rf "${TOOLS_DIR:?}"/bin/*
    log_success "cache" "Cleared .github/tools/cache and bin"
else
    log_info "cache" "Nothing to clean."
fi

# Clean PNPM global store if running locally
if [[ "${ACT:-}" == "true" ]] || [[ -z "${GITHUB_ACTIONS:-}" ]]; then
    log_info "pnpm" "Pruning pnpm store..."
    pnpm store prune >/dev/null 2>&1 || true
fi