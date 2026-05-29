#!/usr/bin/env bash
# ==========================================================
# SCRIPT: sign-artifacts.sh
# PURPOSE: Sign build artifacts using Cosign + GitHub OIDC
# ==========================================================

set -euo pipefail

SIGN_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$SIGN_SCRIPT_DIR/lib/logger.sh"

sign_artifact() {
  local artifact_path="${1:?Missing artifact path}"

  if [[ ! -f "$artifact_path" ]]; then
    log_warn "sign" "Skipping: $artifact_path (File not found)"
    return 0 
  fi

  local filename
  filename=$(basename "$artifact_path")

  local checksum_file="${artifact_path}.sha256"

  log_info "sign" "Generating checksum for $filename"

  sha256sum "$artifact_path" > "$checksum_file"

  log_info "sign" "Signing $filename"

  cosign sign-blob "$artifact_path" \
    --bundle "${artifact_path}.bundle.json" \
    --yes

  log_info "sign" "Signing checksum for $filename"

  cosign sign-blob "$checksum_file" \
    --bundle "${checksum_file}.bundle.json" \
    --yes

  log_success "sign" "Signed: $filename"
}

main() {

  if ! command -v cosign >/dev/null; then
    log_error "sign" "cosign not found"
    exit 1
  fi

  if [[ "$#" -eq 0 ]]; then
    log_error "sign" "No artifacts provided"
    exit 1
  fi

  for artifact in "$@"; do
    sign_artifact "$artifact"
  done

  log_success "sign" "All artifacts signed successfully"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi