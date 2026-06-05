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

PERMISSIONS_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$PERMISSIONS_DIR/core.sh"
source "$PERMISSIONS_DIR/logger.sh"


fix_workspace_permissions() {
    local target="${1:-./}"
    log_info "sys" "Normalizing permissions for $target"
    
    if ! run "chmod permissions" chmod -R u+rwX "$target"; then
        log_warn "sys" "Some permissions could not be modified (expected in restricted containers)"
    fi
    log_info "[permissions-fix]" "Done"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    fix_workspace_permissions "$@"
fi


