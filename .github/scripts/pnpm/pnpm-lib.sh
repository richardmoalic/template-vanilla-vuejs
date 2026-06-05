#!/usr/bin/env bash
# ==========================================================
# LIBRARY: pnpm-lib.sh
# PURPOSE: Shared pnpm helper functions
# VERSION: v1.1.0
# ==========================================================

PNPM_LIB_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$PNPM_LIB_DIR/../lib/core.sh"
source "$PNPM_LIB_DIR/../lib/logger.sh"

require_pnpm() {

    if ! command -v pnpm >/dev/null 2>&1; then
        fail "pnpm is not installed."
    fi
}

pnpm_store_path() {

    require_pnpm

    pnpm store path
}

pnpm_export_store_path() {

    local store_path
    store_path="$(pnpm_store_path)"

    if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
        echo "STORE_PATH=$store_path" >> "$GITHUB_OUTPUT"
    else
        echo "$store_path"
    fi
}

pnpm_fetch() {

    require_pnpm

    log_info "pnpm" "Prefetching dependency store"

    pnpm fetch
}

pnpm_install() {

    require_pnpm

    local secure="${1:-false}"

    local flags=(
        --frozen-lockfile
        --prefer-offline
        --reporter=append-only
    )

    if [[ "$secure" != "true" ]]; then
        flags+=(--ignore-scripts)
    fi

    log_info "pnpm" \
        "Installing dependencies (secure=$secure)"

    pnpm install "${flags[@]}"
}

pnpm_store_verify() {

    require_pnpm

    log_info "pnpm" \
        "Verifying pnpm store integrity"

    pnpm store status
}

pnpm_store_prune() {

    require_pnpm

    log_info "pnpm" \
        "Pruning unused packages"

    pnpm store prune
}