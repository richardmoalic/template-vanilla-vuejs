#!/usr/bin/env bash
# ==========================================================
# SCRIPT: download-file.sh
# VERSION: v1.0.0
# ==========================================================

DOWNLOAD_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "${DOWNLOAD_SCRIPT_DIR}/core.sh"
source "${DOWNLOAD_SCRIPT_DIR}/logger.sh"

download_file() {
  local url="$1" out="$2"

  log_info "[download] $url"

  if [ "${DRY_RUN:-false}" = "true" ]; then
    log_info "[dry-run] curl -L --fail --retry 5 -o $out $url"
    return 0
  fi
  
  run "[Downloading]" curl \
  -L \
  --fail \
  --retry 5 \
  --retry-delay 2 \
  --connect-timeout 10 \
  --progress-bar \
  -o "$out" \
  "$url"

  log_done "Downloading file from" "$url"
}