#!/usr/bin/env bash

# ==========================================================
# SCRIPT: gitleaks.sh
# PURPOSE:
#   Run Gitleaks scan with secure binary installation
#
# FEATURES:
#   - ShellCheck compliant
#   - Dry-run support
#   - Local binary install (~/.local/bin)
#   - SHA256 verification via verify-download.sh
#   - Uses versions.env (pinned versions)
#   - CI blocking / act non-blocking
# USE CASES:
#   - CI security scanning
#   - GitHub Security tab integration
# USED BY:
#   - security.yml → secrets scanning
# EXECUTION:
#   - Invoked as bash script in security scan workflow
# CONTEXT:
#   - Blocking in CI, non-blocking in act
# DEPENDENCIES:
#   - .gitleaks.toml → custom rules & allowlist
# OUTPUT:
#   - results.sarif
# USAGE:
#   DRY_RUN=true ./gitleaks.sh
# MAINTENANCE:
#   - Update gitleaks versions periodically
#   - Owner: @gituser
# VERSION: v3.0.0
# ==========================================================

set -euo pipefail


DRY_RUN="${DRY_RUN:-false}"
GITLEAKS_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"


source "$GITLEAKS_DIR/lib/core.sh"
source "$GITLEAKS_DIR/lib/logger.sh"


run_scan_gitleaks() {
  local report="gitleaks.sarif"
  log_info "[gitleaks]" "Starting secrets detection..."

  if [ "$DRY_RUN" = "true" ]; then
    log_debug "gitleaks" "[dry-run] Writing dummy SARIF"
    echo '{"version":"2.1.0","runs":[]}' > "$report"
    return 0
  fi

  if ! run "[gitleaks] scan" \
  gitleaks detect \
    --source . \
    --report-format sarif \
    --report-path "$report" \
    --redact \
    --verbose
  then
    log_warn "gitleaks" "Potential secrets found. Check $report"
        [[ "${ACT:-}" == "true" ]] && return 0 || return 1
  fi

  log_success "gitleaks" "No secrets detected."
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    core_init
    run_audit_gitleaks
fi