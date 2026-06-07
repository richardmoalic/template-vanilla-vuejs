#!/usr/bin/env bash
#==========================================================
# SCRIPT: install-shdoc.sh
# PURPOSE: 
# TOOL: Shdoc
#==========================================================
set -euo pipefail

SHDOC_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$SHDOC_SCRIPT_DIR/../lib/install.sh"
source "$SHDOC_SCRIPT_DIR/../versions.env"

: "${SHDOC_VERSION:?Missing versions.env}"
: "${SHDOC_URL:?Missing versions.env}"
: "${SHDOC_SHA:?Missing versions.env}"

install_shdoc() {
  install_tool \
    "shdoc" \
    "$SHDOC_VERSION" \
    "$SHDOC_URL" \
    "$SHDOC_SHA" \
    "binary" \
    "shdoc"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_shdoc
fi