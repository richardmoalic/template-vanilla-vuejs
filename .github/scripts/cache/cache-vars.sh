#!/usr/bin/env bash

# ==========================================================
# SCRIPT: cache-vars.sh
# PURPOSE: Cache namespace + path initialization
# ==========================================================

set -euo pipefail


cache_init() {

    echo "cache init called"
    
    if [[ -n "${TOOLS_DIR:-}" ]]; then
        echo "[cache-vars] Environment already initialized. Skipping configuration."
        return 0
    fi

    local workspace_root
    workspace_root="${GITHUB_WORKSPACE:-$(pwd)}"

    local cache_scope

    if [[ "${ACT:-}" == "true" ]]; then
        cache_scope="act-local"

    elif [[ "${GITHUB_EVENT_NAME:-}" == "pull_request" ]]; then
        cache_scope="pr-${GITHUB_EVENT_NUMBER}"

    elif [[ "${GITHUB_REF_NAME:-}" == "main" ]]; then
        cache_scope="prod-main"

    else
        local safe_ref
        safe_ref="$(echo "${GITHUB_REF_NAME:-default}" | tr '/:@' '-')"

        cache_scope="branch-${safe_ref}"
    fi

    # 1. Global Toolchain Core Directories
    export TOOLS_DIR="$workspace_root/.github/tools"
    export CACHE_DIR="$TOOLS_DIR/cache"
    export BIN_DIR="$TOOLS_DIR/bin"

    # 2. Sub-cache Downstreams
    export PNPM_STORE_DIR="$CACHE_DIR/pnpm-store"
    export VITE_CACHE_DIR="$CACHE_DIR/vite"
    export VITEST_CACHE_DIR="$CACHE_DIR/vitest"
    export PLAYWRIGHT_CACHE_DIR="$CACHE_DIR/playwright"
    
    # 3. Cache Versioning Key
    export CACHE_PREFIX="${cache_scope}-v1"

    # Ensure all directories exist safely
    mkdir -p \
        "$TOOLS_DIR" \
        "$CACHE_DIR" \
        "$BIN_DIR" \
        "$PNPM_STORE_DIR" \
        "$VITE_CACHE_DIR" \
        "$VITEST_CACHE_DIR" \
        "$PLAYWRIGHT_CACHE_DIR"

    # Inject variables to downstream GitHub runner containers if available
    if [[ -n "${GITHUB_ENV:-}" ]]; then
        {
            echo "TOOLS_DIR=$TOOLS_DIR"
            echo "CACHE_DIR=$CACHE_DIR"
            echo "BIN_DIR=$BIN_DIR"
            echo "PNPM_STORE_DIR=$PNPM_STORE_DIR"
            echo "VITE_CACHE_DIR=$VITE_CACHE_DIR"
            echo "VITEST_CACHE_DIR=$VITEST_CACHE_DIR"
            echo "PLAYWRIGHT_CACHE_DIR=$PLAYWRIGHT_CACHE_DIR"
            echo "CACHE_PREFIX=$CACHE_PREFIX"
        } >> "$GITHUB_ENV"
    fi

    echo "cache init done"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    cache_init "$@"
fi