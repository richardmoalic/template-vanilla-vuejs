#!/usr/bin/env bash
# ==========================================================
# SCRIPT: verify-download.sh
# PURPOSE: Securely verify file integrity via SHA256
# ==========================================================

set -euo pipefail

VERIFY_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$VERIFY_SCRIPT_DIR/logger.sh"

verify_file() {
  local url="$1"
  local file_path="$2"
  local expected_sha="$3"

  [ -f "$file_path" ] || fail "Verification target missing: $file_path"

  log_step "verify" "Checking SHA256 integrity for $(basename "$url")..."

  if [ "${DRY_RUN:-false}" = "true" ]; then
    log_info "verify" "[dry-run] Would verify SHA256: ${expected_sha}"
  else
    # Perform the checksum check
    if echo "${expected_sha}  ${file_path}" | sha256sum -c --status; then
      log_done "Verified: $(basename "$url")"
    else
      log_error "verify" "SHA256 mismatch!"
      log_error "verify" "Expected: ${expected_sha}"
      log_error "verify" "Actual:   $(sha256sum "$file_path" | awk '{print $1}')"
      fail "Integrity check failed for $url"
    fi
  fi
}