#!/usr/bin/env bash
# ==========================================================
# SCRIPT: pnpm.sh
# PURPOSE: Unified pnpm operations
#
# USAGE:
#   pnpm.sh install
#   pnpm.sh install-secure
#   pnpm.sh fetch
#   pnpm.sh store-path
#   pnpm.sh verify-store
#   pnpm.sh prune-store
#   pnpm.sh help
#
# VERSION: v1.1.0
# ==========================================================

set -euo pipefail

PNPM_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$PNPM_DIR/../lib/core.sh"
source "$PNPM_DIR/../lib/logger.sh"
source "$PNPM_DIR/../pnpm/pnpm-lib.sh"

core_init

usage() {

cat <<EOF
Usage:
  pnpm.sh install
      Install dependencies (ignore lifecycle scripts)

  pnpm.sh install-secure
      Install dependencies with lifecycle scripts enabled

  pnpm.sh fetch
      Prefetch dependencies into pnpm store

  pnpm.sh store-path
      Output pnpm store path

  pnpm.sh verify-store
      Verify store integrity

  pnpm.sh prune-store
      Remove unused packages

  pnpm.sh help
      Display this help
EOF
}

main() {

    case "${1:-help}" in

        install)
            pnpm_install false
            ;;

        install-secure)
            pnpm_install true
            ;;

        fetch)
            pnpm_fetch
            ;;

        store-path)
            pnpm_export_store_path
            ;;

        verify-store)
            pnpm_store_verify
            ;;

        prune-store)
            pnpm_store_prune
            ;;

        help|-h|--help)
            usage
            ;;

        *)
            log_error "pnpm" \
                "Unknown command: $1"

            usage
            exit 1
            ;;
    esac
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi