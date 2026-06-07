#!/usr/bin/env bash
#==========================================================
# SCRIPT: install-d2.sh
# PURPOSE: 
# TOOL: D2
#==========================================================
set -euo pipefail

D2_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$D2_SCRIPT_DIR/../lib/install.sh"
source "$D2_SCRIPT_DIR/../versions.env"

: "${D2_VERSION:?Missing versions.env}"
: "${D2_URL:?Missing versions.env}"
: "${D2_SHA:?Missing versions.env}"

install_d2() {
  install_tool \
    "d2" \
    "$D2_VERSION" \
    "$D2_URL" \
    "$D2_SHA" \
    "tar" \
    "d2"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_d2
fi