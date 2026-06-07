#!/usr/bin/env bash
# ==========================================================
# SCRIPT: docs.sh
# PURPOSE: Unified documentation entry point
# ==========================================================
set -euo pipefail

DOCS_ENTRY_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# 1. Load Security/Core logic
source "$DOCS_ENTRY_DIR/../lib/core.sh"
source "$DOCS_ENTRY_DIR/../lib/logger.sh"
source "$DOCS_ENTRY_DIR/../install/install-d2.sh"
source "$DOCS_ENTRY_DIR/../install/install-shdoc.sh"

# 2. Load Generation logic
source "$DOCS_ENTRY_DIR/../build/generate-docs.sh"
source "$DOCS_ENTRY_DIR/../build/generate-d2.sh"
source "$DOCS_ENTRY_DIR/../build/generate-shdoc.sh"
source "$DOCS_ENTRY_DIR/../build/generate-typedoc.sh"
source "$DOCS_ENTRY_DIR/../build/generate-docs.sh"

core_init

case "${1:-all}" in
    install)
        install_d2
        install_shdoc
        ;;
    templates)
        generate_templates
        ;;
    diagrams)
        ensure_file "d2" "$D2_VERSION" "$D2_URL" "$D2_SHA" "tar" "d2"
        generate_d2_docs
        ;;
    shell)
        ensure_file "shdoc" "$SHDOC_VERSION" "$SHDOC_URL" "$SHDOC_SHA" "binary" "shdoc"
        generate_shell_docs
        ;;
    refs)
        # Ensure tools then run reference generation
        ensure_file "d2" "$D2_VERSION" "$D2_URL" "$D2_SHA" "tar" "d2"
        ensure_file "shdoc" "$SHDOC_VERSION" "$SHDOC_URL" "$SHDOC_SHA" "binary" "shdoc"
        generate_d2_docs
        generate_shell_docs
        ;;
    typedoc)
        generate_typedoc
        ;;
    all)
        log_info "docs" "Running full documentation pipeline..."
        # 1. Setup
        ensure_file "d2" "$D2_VERSION" "$D2_URL" "$D2_SHA" "tar" "d2"
        ensure_file "shdoc" "$SHDOC_VERSION" "$SHDOC_URL" "$SHDOC_SHA" "binary" "shdoc"
        
        # 2. Execute
        generate_templates
        generate_d2_docs
        generate_shell_docs
        generate_typedoc
        
        log_success "docs" "Pipeline complete. Run 'pnpm docs:dev' to preview."
        ;;
    *)
        echo "Usage: $0 {all|install|templates|diagrams|shell|refs}"
        exit 1
        ;;
esac