#!/usr/bin/env bash
set -euo pipefail

D2_GEN_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$D2_GEN_DIR/../lib/logger.sh"

generate_d2_docs() {
    local src_dir="docs/diagrams"
    local out_dir="docs/public/diagrams"

    mkdir -p "$out_dir"
    shopt -s nullglob
    local count=0

    for file in "$src_dir"/*.d2; do
        local name
        name="$(basename "$file" .d2)"
        log_info "d2" "Rendering ${name}.svg"

        "$BIN_DIR/d2" --theme 200 "$file" "$out_dir/${name}.svg"
        count=$((count+1))
    done

    shopt -u nullglob
    log_success "d2" "Generated ${count} diagrams"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    generate_d2_docs
fi