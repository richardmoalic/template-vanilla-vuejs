#!/usr/bin/env bash
# ==========================================================
# SCRIPT: audit-signatures.sh
# PURPOSE: Audit node modules signatures
# ==========================================================

set -euo pipefail

AUDIT_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$AUDIT_SCRIPT_DIR/lib/logger.sh"

audit_node_modules(){
log_info "audit" "Verifying dependency signatures via Sigstore..."
local audit_file="pnpm-audit-signatures.json"

  # Run machine-readable audit output
  if ! pnpm audit signatures --json > "$audit_file"; then
    log_error "audit" "Dependency signature verification failed!"
    
    log_info "audit" "Writing report to file..."
    cat "$audit_file"

    exit 1
  fi

  log_success "audit" "All dependencies have valid signatures."

  log_info "audit" "Audit report saved to $audit_file"

}

main() {
audit_node_modules "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi