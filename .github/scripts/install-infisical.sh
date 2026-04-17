#!/usr/bin/env bash
set -euo pipefail

INFISICAL_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$INFISICAL_SCRIPT_DIR/lib/core.sh"
source "$INFISICAL_SCRIPT_DIR/lib/install.sh"
source "$INFISICAL_SCRIPT_DIR/versions.env"

install_infisical() {
  install_tool \
    "infisical" \
    "$INFISICAL_VERSION" \
    "$INFISICAL_URL" \
    "$INFISICAL_SHA" \
    "tar" \
    "infisical"
}

main() {
install_infisical

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi