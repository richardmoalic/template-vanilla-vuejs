#!/usr/bin/env bash
# ==========================================================
# SCRIPT: setup-tools.sh
# PURPOSE: Orchestrate the installation of all security tools
# ==========================================================

set -euo pipefail

SETUP_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# Source the orchestrator dependencies
source "$SETUP_SCRIPT_DIR/versions.env"
source "$SETUP_SCRIPT_DIR/install-cosign.sh"
source "$SETUP_SCRIPT_DIR/gitleaks.sh"
source "$SETUP_SCRIPT_DIR/trufflehog.sh"
source "$SETUP_SCRIPT_DIR/install-infisical.sh"
source "$SETUP_SCRIPT_DIR/install-syft.sh"
source "$SETUP_SCRIPT_DIR/lib/logger.sh"


main() {
    log_info "🛡️ [orchestrator] Bootstrapping security environment..."
    
    # 1. Always bootstrap the verifier first
    install_cosign
    install_infisical
    
    # 2. Install scanners
    install_gitleaks
    install_trufflehog

    # install software Bill of Materials tool
    install_syft
    log_done "[orchestrator] All tools verified and installed."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi