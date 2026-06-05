#!/usr/bin/env bash
# ==========================================================
# SCRIPT: typedoc.sh
# PURPOSE: Generate TypeDoc markdown references
# VERSION: v1.0.0
# ==========================================================

set -euo pipefail

TYPEDOC_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$TYPEDOC_SCRIPT_DIR/../lib/core.sh"
source "$TYPEDOC_SCRIPT_DIR/../lib/logger.sh"
source "$TYPEDOC_SCRIPT_DIR/../pnpm/pnpm-lib.sh"

generate_typedoc() {

    require_pnpm

    if ! pnpm exec typedoc --version >/dev/null 2>&1; then
        fail "typedoc dependency missing"
    fi

    if [[ ! -f "typedoc.json" ]]; then
        log_warn "typedoc" \
            "typedoc.json not found. Skipping."

        return 0
    fi

    log_info "typedoc" \
        "Generating API reference"

    pnpm exec typedoc \
        --options typedoc.json

    log_success "typedoc" \
        "API reference generated"
}