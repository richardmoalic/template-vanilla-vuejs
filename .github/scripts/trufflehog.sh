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
run_scan() {
  log_info "[trufflehog] Starting scan..."

  
  if [ "$DRY_RUN" = "true" ]; then
    log_debug "[dry-run] trufflehog detect ..."
    return 0
  fi

set +e
trufflehog git file://"$PWD" --only-verified --json > trufflehog.json
EXIT_CODE=$?
set -e

log_step "[trufflehog] Converting to SARIF..."

if [ -s trufflehog.json ]; then
  jq -s '{
    version: "2.1.0",
    runs: [{
      tool: { driver: { name: "TruffleHog" } },
      results: map({
        ruleId: "secret-detected",
        message: { text: "Verified secret detected" },
        locations: [{
          physicalLocation: {
            artifactLocation: { uri: .SourceMetadata.Data.Git.file },
            region: { startLine: (.SourceMetadata.Data.Git.line | tonumber) }
          }
        }]
      })
    }]
  }' trufflehog.json > trufflehog.sarif
else
  log_info '{"runs":[]}' > trufflehog.sarif
fi

if [ "$EXIT_CODE" -eq 0 ]; then
  log_success "[trufflehog] No verified secrets found"
  exit 0
fi

if [ "${ACT:-}" = "true" ]; then
  log_warn "::warning::[trufflehog] Secrets found (non-blocking in act)"
  exit 0
else
  log_error "[trufflehog] Verified secrets detected!"
  exit 1
fi

}

main(){
  install_trufflehog
  run_scan
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi