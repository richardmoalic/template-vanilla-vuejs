#!/usr/bin/env bash
set -euo pipefail

GENERATE_VEX_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$GENERATE_VEX_SCRIPT_DIR/../versions.env"
source "$GENERATE_VEX_SCRIPT_DIR/../lib/logger.env"



apply_vex() {
  local report="$1"
  local vex_file=".github/security/exceptions.vex.json"
  
  log_info "vex" "Filtering $report using $vex_file"
  "$BIN_DIR/vexctl" filter "$report" "$vex_file" > "${report}.filtered"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    apply_vex "$@"
fi