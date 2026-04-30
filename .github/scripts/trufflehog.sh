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

source "$TRUFFLEHOG_DIR/lib/core.sh"

# shellcheck source=lib/install.sh
source "$TRUFFLEHOG_DIR/lib/install.sh"

# shellcheck source=versions.env
source "$TRUFFLEHOG_DIR/versions.env"

: "${TRUFFLEHOG_VERSION:?Missing versions.env}"
: "${TRUFFLEHOG_URL:?Missing versions.env}"
: "${TRUFFLEHOG_SHA:?Missing versions.env}"


install_trufflehog() {
  install_tool \
  "trufflehog" \
  "$TRUFFLEHOG_VERSION" \
  "$TRUFFLEHOG_URL" \
  "$TRUFFLEHOG_SHA" \
  "tar" \
  "trufflehog"

}

# Run scan
run_scan_trufflehog() {
  log_info "[trufflehog] Starting scan..."


  if [ "${DRY_RUN:-false}" = "true" ]; then
    log_debug "[dry-run] trufflehog scan"
    return 0
  fi

  local json="trufflehog.json"

  run "[trufflehog]" \
    "trufflehog git file://\"$PWD\" --only-verified --no-update --json > \"$json\""

    local status=$?

    if [ $status -ne 0 ] && [ ! -s "$json" ]; then
      log_error "[trufflehog] scan failed unexpectedly"
    return $status
  fi

  # Non-empty JSON → fail CI
  if [ -s "$json" ]; then
    log_error "[trufflehog] verified secrets detected! See $json"
    return 1
  fi

  log_success "[trufflehog] scan completed"
  return 0

}

main(){
  install_trufflehog
  run_scan_trufflehog
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi