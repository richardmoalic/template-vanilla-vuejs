#!/usr/bin/env bash
set -euo pipefail

TRUFFLEHOG_INSTALL_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$TRUFFLEHOG_INSTALL_DIR/../lib/install.sh"
source "$TRUFFLEHOG_INSTALL_DIR/../versions.env"

: "${TRUFFLEHOG_VERSION:?Missing versions.env}"
: "${TRUFFLEHOG_URL:?Missing versions.env}"
: "${TRUFFLEHOG_SHA:?Missing versions.env}"

install_trufflehog() {
    install_tool \
        "trufflehog" \
        "$TRUFFLEHOG_VERSION" \
        "$TRUFFLEHOG_URL" \
        "$TRUFFLEHOG_SHA" \
        "tar" \
        "trufflehog"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_trufflehog
fi