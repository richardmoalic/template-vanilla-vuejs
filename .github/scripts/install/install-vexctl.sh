#!/usr/bin/env bash
set -euo pipefail

VEX_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$VEX_SCRIPT_DIR/../lib/install.sh"
source "$VEX_SCRIPT_DIR/../versions.env"

: "${VEXCTL_VERSION:?Missing versions.env}"
: "${VEXCTL_URL:?Missing versions.env}"
: "${VEXCTL_SHA:?Missing versions.env}"

install_vexctl() {
  install_tool "vexctl" "$VEXCTL_VERSION" "$VEXCTL_URL" "$VEXCTL_SHA" "binary" "vexctl"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_vexctl
fi