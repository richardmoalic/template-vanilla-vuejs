#!/usr/bin/env bash
set -euo pipefail

INFISICAL_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$INFISICAL_SCRIPT_DIR/../lib/install.sh"
source "$INFISICAL_SCRIPT_DIR/../versions.env"

: "${INFISICAL_VERSION:?Missing versions.env}"
: "${INFISICAL_URL:?Missing versions.env}"
: "${INFISICAL_SHA:?Missing versions.env}"

install_infisical() {
  install_tool \
    "infisical" \
    "$INFISICAL_VERSION" \
    "$INFISICAL_URL" \
    "$INFISICAL_SHA" \
    "tar" \
    "infisical"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_infisical
fi