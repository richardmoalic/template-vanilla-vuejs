#!/usr/bin/env bash
#==========================================================
# SCRIPT: install-syft.sh
# PURPOSE: 
# TOOL: Syft
#==========================================================
set -euo pipefail

SYFT_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$SYFT_SCRIPT_DIR/lib/core.sh"
source "$SYFT_SCRIPT_DIR/lib/install.sh"
source "$SYFT_SCRIPT_DIR/versions.env"
source "$SYFT_SCRIPT_DIR/lib/logger.sh"

install_syft() {
  install_tool \
    "syft" \
    "$SYFT_VERSION" \
    "$SYFT_URL" \
    "$SYFT_SHA" \
    "tar" \
    "syft"
}

generate_SBOM(){
  
if [ -f package.json ]; then
  PROJ_NAME=$(node -p "require('./package.json').name" 2>/dev/null || echo "unknown")
  PROJ_VER=$(node -p "require('./package.json').version" 2>/dev/null || echo "0.0.0")
else
  PROJ_NAME="unknown"
  PROJ_VER="0.0.0"
fi

log_info "sbom" "Project: $PROJ_NAME@$PROJ_VER"

log_start "SBOM Generation"

run syft dir:. \
  --source-name "$PROJ_NAME" \
  --source-version "$PROJ_VER" \
  -o cyclonedx-json=bom.json

log_success "sbom" "SBOM generated: bom.json"
}

main() {
  install_syft
  generate_SBOM
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi