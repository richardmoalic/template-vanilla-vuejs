#!/usr/bin/env bash
set -euo pipefail

GEN_DOCS_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$GEN_DOCS_DIR/../lib/logger.sh"

TEMPLATE_DIR=".github/doc-templates"
GUIDE_OUT_DIR="docs/guide"

# Metadata setup
DOC_DATE="${DOC_DATE:-$(date -u +%F)}"
COMMIT_REF="$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")"
DOC_VERSION="${DOC_VERSION:-$COMMIT_REF}"

render_template() {
    local source="$1"
    sed \
        -e "s/{{DATE}}/${DOC_DATE}/g" \
        -e "s/{{VERSION}}/${DOC_VERSION}/g" \
        -e "s/{{COMMIT_REF}}/${COMMIT_REF}/g" \
        "$source"
}

generate_templates() {
    mkdir -p "$GUIDE_OUT_DIR"
    log_info "docs" "Scaffolding guides from templates..."

    shopt -s nullglob
    for template in "$TEMPLATE_DIR"/*.md; do
        local filename
        filename="$(basename "$template")"
        
        # Don't overwrite if you've made manual edits in docs/guide
        if [[ -f "$GUIDE_OUT_DIR/$filename" ]]; then
            log_warn "docs" "Skipping $filename (already exists)"
            continue
        fi

        render_template "$template" > "$GUIDE_OUT_DIR/$filename"
        log_success "docs" "Rendered $filename"
    done
    shopt -u nullglob
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    generate_templates
fi