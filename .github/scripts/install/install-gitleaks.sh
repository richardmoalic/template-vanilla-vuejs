#!/usr/bin/env bash

# ==========================================================
# SCRIPT: install-gitleaks.sh
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
GITLEAKS_INSTALL_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"


source "$GITLEAKS_INSTALL_DIR/lib/logger.sh"
source "$GITLEAKS_INSTALL_DIR/lib/install.sh"
source "$GITLEAKS_INSTALL_DIR/versions.env"


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
  "gitleaks" \

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_gitleaks
fi