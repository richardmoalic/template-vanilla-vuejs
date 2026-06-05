#!/usr/bin/env bash
#==========================================================
# SCRIPT: generate-sbom.sh
# PURPOSE: 
# TOOL: Syft
#==========================================================
set -euo pipefail

GENERATE_SBOM_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$GENERATE_SBOM_SCRIPT_DIR/../lib/core.sh"
source "$GENERATE_SBOM_SCRIPT_DIR/../lib/logger.sh"


generate_SBOM(){
  
  PROJ_VER="${OVERRIDE_VERSION:-$(node -p "require('./package.json').version" 2>/dev/null || echo "0.0.0")}"
  PROJ_NAME=$(node -p "require('./package.json').name" 2>/dev/null || echo "unknown")

log_info "sbom" "Project: $PROJ_NAME@$PROJ_VER"

run "[Generating SBOM]" syft dir:. \
  --source-name "$PROJ_NAME" \
  --source-version "$PROJ_VER" \
  -o cyclonedx-json=bom.json

log_success "sbom" "SBOM generated: bom.json"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  generate_SBOM
fi