#!/usr/bin/env bash
# ==========================================================
# SCRIPT: verify-download.sh
# PURPOSE:
#   Securely download and verify binaries (SHA256 + optional GPG)
#
# FEATURES:
#   - SHA256 checksum validation (mandatory)
#   - Optional GPG signature verification
#   - No sudo required
#   - Reusable across scripts
#
# USAGE:
#   verify_download <url> <output_file> <expected_sha256> [gpg_sig_url] [gpg_key]
#
# EXAMPLE:
#   verify_download "$URL" "$TMP" "$SHA"
#
# VERSION: v1.0.0
# ==========================================================

set -euo pipefail

VERIFY_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$VERIFY_SCRIPT_DIR/logger.sh"

if ! command -v run >/dev/null 2>&1; then
  run() { if [ "${DRY_RUN:-false}" = "true" ]; then log_info "[dry-run] $*"; else "$@"; fi; }
fi

verify_file() {
  local url="$1"
  local file_path="$2"
  local expected_sha="$3"
  local provider="${4:-}"
  local auth_data="${5:-}"
  local sig_url="${6:-}"
  local cert_url="${7:-}"

  [ -f "$file_path" ] || fail "Verification target missing: $file_path"

  # 1. MANDATORY: SHA256 Integrity
  if [ "${DRY_RUN:-false}" = "true" ]; then
    log_step "verify" "[dry-run] Would verify SHA256: ${expected_sha}"
  else
    log_step "verify" "Checking SHA256 integrity..."
    echo "${expected_sha}  ${file_path}" | sha256sum -c - || fail "SHA256 mismatch for $url"
  fi

  # 2. OPTIONAL: Identity Verification (GPG/Sigstore)
  case "$provider" in
    gpg)
      log_step "verify" "Verifying GPG signature..."
      local sig_file; sig_file="$(mktemp)"
      
      # We still need to download the signature itself
      log_step "Downloading signature"
      download_file "$sig_url" "$sig_file"
      
      if [ "${DRY_RUN:-false}" != "true" ]; then
        local gnupg_home; gnupg_home="$(mktemp -d)"
        GNUPGHOME="$gnupg_home" gpg --import <<< "$auth_data" &>/dev/null
        GNUPGHOME="$gnupg_home" gpg --verify "$sig_file" "$file_path" || fail "GPG verification failed"
        rm -rf "$gnupg_home"
      fi
      rm -f "$sig_file"
      ;;

    sigstore)
      command -v cosign >/dev/null 2>&1 || fail "Cosign not found"
      
      log_info "verify" "Verifying Sigstore identity..."
      local tmp_sig; tmp_sig="$(mktemp)"
      local tmp_cert; tmp_cert="$(mktemp)"
      
      log_step "Downloading signature"
      download_file "$sig_url" "$tmp_sig"
      download_file "$cert_url" "$tmp_cert"

      log_warn "[verify]" "File type: $(file "$file_path")"
      log_warn "[verify]" "SHA: $(sha256sum "$file_path")"

      run cosign verify-blob "$file_path" \
        --signature "$tmp_sig" \
        --certificate "$tmp_cert" \
        --certificate-identity "$auth_data" \
        --certificate-oidc-issuer "https://token.actions.githubusercontent.com"

      rm -f "$tmp_sig" "$tmp_cert"
      ;;

    "") : ;; # Integrity only
    *) fail "Unknown verification provider: $provider" ;;
  esac

  log_done "Verified: $(basename "$url")"
}