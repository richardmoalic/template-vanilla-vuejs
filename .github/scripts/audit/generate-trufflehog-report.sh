#!/usr/bin/env bash
#==========================================================
# SCRIPT: trufflehog.sh
# PURPOSE: Detect verified secrets using TruffleHog
# USE CASES:
#   - Deep scan (verified secrets only)
#   - Complements Gitleaks
# USED BY:
#   - security.yml → secrets scanning
# EXECUTION:
#   - Invoked as bash script in security scan workflow
# CONTEXT:
#   - Blocking in CI, non-blocking in act
# DEPENDENCIES:
#   - trufflehog.yml → custom rules & reporting
# OUTPUT:
#   - trufflehog.sarif (converted from JSON)
# MAINTENANCE:
#   - Update trufflehog versions periodically
#   - Owner: @gituser
# VERSION: v1.0.0
#==========================================================

set -euo pipefail


TRUFFLEHOG_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$TRUFFLEHOG_DIR/../lib/core.sh"
source "$TRUFFLEHOG_DIR/../lib/install.sh"


run_scan_trufflehog() {
  log_info "[trufflehog]" "Starting scan..."
  local json="trufflehog.json"

  ensure_file "trufflehog" "$TRUFFLEHOG_VERSION" "$TRUFFLEHOG_URL" "$TRUFFLEHOG_SHA" "tar" "trufflehog"


  if [ "${DRY_RUN:-false}" = "true" ]; then
    log_debug "trufflehog" "[dry-run] Skipping scan"
    return 0
  fi


   if ! run "[trufflehog] scan" \
    trufflehog git "file://$PWD" \
      --only-verified \
      --no-update \
      --json \
      > "$json"
  then
    if [[ -s "$json" ]]; then
            log_error "trufflehog" "VERIFIED secrets detected in history!"
            return 1
    fi
  fi

  log_success "trufflehog" "Clean scan (no verified secrets found)."
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  core_init
  run_scan_trufflehog
fi