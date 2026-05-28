#!/usr/bin/env bash
# ==========================================================
# SCRIPT: security.sh
# PURPOSE: Unified entry point for security operations
# USAGE: ./security.sh [install|scan|sbom|verify]
# ==========================================================

set -euo pipefail

SECURITY_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# 1. Global Initialization (Load libs once)
source "$SECURITY_DIR/lib/core.sh"
source "$SECURITY_DIR/lib/install.sh"
source "$SECURITY_DIR/versions.env"
source "$SECURITY_DIR/lib/logger.sh"

# 2. Source Tool Logics (without auto-executing main)
source "$SECURITY_DIR/install-infisical.sh"
source "$SECURITY_DIR/install-cosign.sh"
source "$SECURITY_DIR/install-syft.sh"
source "$SECURITY_DIR/gitleaks.sh"
source "$SECURITY_DIR/trufflehog.sh"
source "$SECURITY_DIR/sign-artifacts.sh"
source "$SECURITY_DIR/audit-signatures.sh"

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
    log_info "action" "Verifying artifact signature..."
    install_cosign

    cosign verify-blob "${2}" \
    --bundle "${3}" \
    --certificate-identity "https://github.com/${GITHUB_REPOSITORY}/.github/workflows/release.yml@refs/heads/main" \
    --certificate-oidc-issuer "https://token.actions.githubusercontent.com"
    ;;

  sign)
    log_info "action" "Signing artifact..."
    install_cosign
    shift

    sign_artifact "$@"
  ;;

  audit)
    log_info "action" "Auditing signatures..."
    audit_node_modules
;;

  *)
    echo "Usage: $0 {install|scan|sbom|verify}"
    exit 1
    ;;
esac