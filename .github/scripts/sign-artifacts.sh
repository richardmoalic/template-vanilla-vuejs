#!/usr/bin/env bash
# ==========================================================
# SCRIPT: sign-artifacts.sh
# PURPOSE: Sign build artifacts using Cosign + GitHub OIDC
# ==========================================================

set -euo pipefail

SIGN_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$SIGN_SCRIPT_DIR/lib/logger.sh"

generate_checksums() {
  local output_file="${1:-checksums.txt}"
  shift

  : > "$output_file"

  for artifact in "$@"; do
    if [[ -f "$artifact" ]]; then
      sha256sum "$artifact" >> "$output_file"
    else
      log_warn "sign" "Skipping missing file: $artifact"
    fi
  done

  log_success "sign" "Generated $output_file"
}

sign_checksums() {
  local checksums_file="${1:-checksums.txt}"

  [[ -f "$checksums_file" ]] || {
    log_error "sign" "$checksums_file not found"
    exit 1
  }

  log_info "sign" "Signing $checksums_file"

  cosign sign-blob "$checksums_file" \
    --bundle "${checksums_file}.bundle.json" \
    --yes

  log_success "sign" "Signed $checksums_file"
}