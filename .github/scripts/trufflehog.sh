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

  
  local json="trufflehog.json"
  local sarif="trufflehog.sarif"

  if [ "${DRY_RUN:-false}" = "true" ]; then
    log_debug "[dry-run] trufflehog scan"
    ensure_file "$sarif" '{"version":"2.1.0","runs":[]}'
    return 0
  fi

run "[trufflehog] scan" trufflehog git file://"$PWD" --only-verified --json > trufflehog.json

  if [ ! -s "$json" ]; then
    log_warn "[trufflehog] No output JSON generated"
    ensure_file "$sarif" '{"version":"2.1.0","runs":[]}'
    return 0
  fi

  run "[trufflehog]" \
    "jq -s '{version:\"2.1.0\",runs:[{tool:{driver:{name:\"TruffleHog\"}},results:map({ruleId:\"secret\",message:{text:\"secret\"},locations:[]})}]}' $json > $sarif"

  ensure_file "$sarif" '{"version":"2.1.0","runs":[]}'

  log_success "[trufflehog] scan completed"

}

main(){
  install_trufflehog
  run_scan
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi