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
local filename
filename=$(basename "$artifact_path")
local checksum_file="${artifact_path}.sha256"

log_info "sign" "Generating checksum for $filename"
sha256sum "$artifact_path" | tee "${artifact_path}.sha256"

# Ensure cosign is installed
if ! command -v cosign >/dev/null; then
    log_error "sign" "cosign not found"
    exit 1
fi

# Sign artifact
  cosign sign-blob "$artifact_path" \
    --bundle "${artifact_path}.bundle.json" \
    --yes

  # Sign checksum
  cosign sign-blob "$checksum_file" \
    --bundle "${checksum_file}.bundle.json" \
    --yes


log_success "sign" "Artifact signed successfully"

}

main() {
sign_artifact "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi