#!/usr/bin/env bash
#==========================================================
# SCRIPT: install-syft.sh
# PURPOSE: 
# TOOL: Syft
#==========================================================
set -euo pipefail

SYFT_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$SYFT_SCRIPT_DIR/../lib/install.sh"
source "$SYFT_SCRIPT_DIR/../versions.env"

: "${SYFT_VERSION:?Missing versions.env}"
: "${SYFT_URL:?Missing versions.env}"
: "${SYFT_SHA:?Missing versions.env}"

install_syft() {
  install_tool \
    "syft" \
    "$SYFT_VERSION" \
    "$SYFT_URL" \
    "$SYFT_SHA" \
    "tar" \
    "syft"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_syft
fi