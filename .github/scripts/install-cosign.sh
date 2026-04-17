#!/usr/bin/env bash

# ==========================================================
# SCRIPT: install-cosign.sh
# PURPOSE:
#   Install cosign (Sigstore) binary securely
#
# FEATURES:
#   - Local install (~/.local/bin)
#   - SHA256 verification
#   - No sudo required
#   - Idempotent (skips if already installed)
#
# USAGE:
#   source install-cosign.sh && install_cosign
#
# VERSION: v1.0.0
# ==========================================================

set -euo pipefail


DRY_RUN="${DRY_RUN:-false}"
COSIGN_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$COSIGN_SCRIPT_DIR/lib/core.sh"

# shellcheck source=lib/install.sh
source "$COSIGN_SCRIPT_DIR/lib/install.sh"

# shellcheck source=versions.env
source "$COSIGN_SCRIPT_DIR/versions.env"

: "${COSIGN_VERSION:?Missing COSIGN_VERSION in versions.env}"
: "${COSIGN_URL:?Missing COSIGN_URL in versions.env}"
: "${COSIGN_SHA:?Missing COSIGN_SHA in versions.env}"


install_cosign() {

  install_tool \
  "cosign" \
  "$COSIGN_VERSION" \
  "$COSIGN_URL" \
  "$COSIGN_SHA" \
  "binary" \
  "cosign"
}

main() {
  install_cosign
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi