#!/usr/bin/env bash
set -euo pipefail

SHDOC_GEN_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$SHDOC_GEN_DIR/../lib/logger.sh"

generate_shell_docs() {
    local src_dir=".github/scripts"
    local out_dir="docs/reference/shell"

    mkdir -p "$out_dir"
    shopt -s globstar nullglob

    local count=0

    for script in "$src_dir"/**/*.sh; do
        if [[ "$script" == *"generate-"* ]] || [[ "$script" == *"docs.sh"* ]]; then continue; fi

        local name
        name="$(basename "$script" .sh)"
        log_info "shdoc" "Generating ${name}.md"

        "$BIN_DIR/shdoc" < "$script" > "$out_dir/${name}.md"
        count=$((count+1))
    done

    shopt -u globstar nullglob
    log_success "shdoc" "Generated ${count} documents"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  generate_shell_docs
fi