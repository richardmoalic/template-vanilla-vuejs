#!/usr/bin/env bash
# ==========================================================
# SCRIPT: generate-docs.sh
# PURPOSE: Scaffold project documentation using templates
# USAGE: ./generate-docs.sh [all|security|release|architecture]
# ==========================================================

set -euo pipefail

DOCS_DIR="docs"
TEMPLATE_DIR=".github/doc-templates"
COMMIT_REF="$(git rev-parse HEAD)"

log() { echo -e "\033[0;34mℹ️  [docs]\033[0m $1"; }
warn() { echo -e "\033[0;33m⚠️  [warn]\033[0m $1"; }
success() { echo -e "\033[0;32m✅ [success]\033[0m $1"; }

mkdir -p "$DOCS_DIR"

DOC_DATE="${DOC_DATE:-$(date -u +%F)}"

DOC_VERSION="${DOC_VERSION:-}"

if [[ -z "$DOC_VERSION" ]]; then
    if git describe --tags --exact-match >/dev/null 2>&1; then
        DOC_VERSION="$(git describe --tags --exact-match)"
    elif git rev-parse --short HEAD >/dev/null 2>&1; then
        DOC_VERSION="$(git rev-parse --short HEAD)"
    else
        DOC_VERSION="development"
    fi
fi

render_template() {
    local source="$1"

    sed \
        -e "s/{{DATE}}/${DOC_DATE}/g" \
        -e "s/{{VERSION}}/${DOC_VERSION}/g" \
        -e "s/{{COMMIT_REF}}/${COMMIT_REF}/g" \
        "$source"
}

create_from_template() {
    local filename="$1"

    local target="$DOCS_DIR/$filename"
    local source="$TEMPLATE_DIR/$filename"

    if [[ -f "$target" ]]; then
        warn "Existing file found at $target. Skipping to prevent overwrite."
        return 0
    fi

    if [[ ! -f "$source" ]]; then
        warn "Template $filename not found."

        cat > "$target" <<EOF
# ${filename%.*}

> Generated: ${DOC_DATE}
> Version: ${DOC_VERSION}
> Commit: ${COMMIT_REF}
EOF

        success "Generated $target"
        return
    fi

    render_template "$source" > "$target"

    success "Generated $target"
}

main() {
    case "${1:-all}" in
        security|release|architecture)
            create_from_template "${1}.md"
            ;;
        all)
            log "Scaffolding all documentation..."

            create_from_template "security.md"
            create_from_template "release.md"
            create_from_template "architecture.md"
            ;;
        *)
            echo "Usage: $0 {all|security|release|architecture}"
            exit 1
            ;;
    esac
}

main "$@"