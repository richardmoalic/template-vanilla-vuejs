#!/usr/bin/env bash
# ==========================================================
# SCRIPT: security.sh
# PURPOSE: Unified entry point for security operations
# USAGE: ./security.sh [install|scan|sbom|verify]
# ==========================================================

set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# 1. Global Initialization (Load libs once)
source "$SCRIPT_DIR/lib/core.sh"
source "$SCRIPT_DIR/lib/install.sh"
source "$SCRIPT_DIR/versions.env"

# 2. Source Tool Logics (without auto-executing main)
source "$SCRIPT_DIR/install-cosign.sh"
source "$SCRIPT_DIR/install-infisical.sh"
source "$SCRIPT_DIR/install-syft.sh"
source "$SCRIPT_DIR/gitleaks.sh"
source "$SCRIPT_DIR/trufflehog.sh"

core_init

case "${1:-}" in
  install)
    log_info "action" "Installing all security tools..."
    install_cosign
    install_infisical
    install_syft
    install_gitleaks
    install_trufflehog
    ;;
    
  scan)
    log_info "action" "Running secret scanners..."
    # Ensure tools exist before scanning
    install_gitleaks
    install_trufflehog
    run_scan_gitleaks
    run_scan_trufflehog
    ;;
    
  sbom)
    log_info "action" "Generating SBOM..."
    install_syft
    export OVERRIDE_VERSION="${2:-}"
    generate_SBOM
    ;;
    
  verify)
    log_info "action" "Verifying environment integrity..."
    install_cosign

    ;;
    
  *)
    echo "Usage: $0 {install|scan|sbom|verify}"
    exit 1
    ;;
esac