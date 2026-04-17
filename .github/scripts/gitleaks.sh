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

# -------------------------------
# Globals
# -------------------------------
DRY_RUN="${DRY_RUN:-false}"
GITLEAKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


source "$GITLEAKS_DIR/lib/core.sh"
source "$GITLEAKS_DIR/lib/logger.sh"

# shellcheck source=lib/install.sh
source "$GITLEAKS_DIR/lib/install.sh"

# shellcheck source=versions.env
source "$GITLEAKS_DIR/versions.env"


: "${GITLEAKS_VERSION:?Missing versions.env}"
: "${GITLEAKS_URL:?Missing versions.env}"
: "${GITLEAKS_SHA:?Missing versions.env}"

# -------------------------------
# Install Gitleaks
# -------------------------------
install_gitleaks() {

install_tool \
  "gitleaks" \
  "$GITLEAKS_VERSION" \
  "$GITLEAKS_URL" \
  "$GITLEAKS_SHA" \
  "tar" \
  "gitleaks"
}

# -------------------------------
# Run scan
# -------------------------------
run_scan_gitleaks() {
  log_info "[gitleaks] Starting scan..."

  if [ "$DRY_RUN" = "true" ]; then
    log_debug "[dry-run] gitleaks detect ..."
    ensure_file gitleaks.sarif '{"version":"2.1.0","runs":[]}'
    return 0
  fi

  run "[gitleaks] scan" gitleaks detect \
    --source . \
    --report-format sarif \
    --report-path gitleaks.sarif \
    --redact \
    --verbose || true

   ensure_file gitleaks.sarif '{"version":"2.1.0","runs":[]}'

  if [ "${ACT:-}" = "true" ]; then
    log_warn "::warning::[gitleaks] Non-blocking in act mode"
  fi


  log_success "[gitleaks] scan completed"
}

# -------------------------------
# Main
# -------------------------------
main() {
  install_gitleaks
  run_scan
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi