#!/usr/bin/env bash
# ==========================================================
# SCRIPT: generate-checksums.sh
# PURPOSE: Deterministically hash existing artifacts
# USAGE: ./generate-checksums.sh <output_file> <input_file1> [input_file2...]
# ==========================================================

set -euo pipefail

GENERATE_CHECKSUMS_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$GENERATE_CHECKSUMS_SCRIPT_DIR/lib/logger.sh"

# Check for minimum arguments
if [ "$#" -lt 2 ]; then
    log_info "Usage: $0 <output_file> <input_file1> [input_file2...]"
    exit 1
fi

OUTPUT_FILE="$1"
shift # Remove the first argument so $@ only contains input files
INPUT_FILES=("$@")

# Reset/Create the output file
: > "$OUTPUT_FILE"

log_info "📝 Generating SHA256 checksums..."

for file in "${INPUT_FILES[@]}"; do
    if [ -f "$file" ]; then
        # Perform the hash and append to output
        # We use 'sha256sum' but format it clearly
        sha256sum "$file" >> "$OUTPUT_FILE"
        log_info "✅ Hashed: $file"
    else
        log_warn "⚠️  Skipped: $file (Not found or empty)"
    fi
done

# Final check: if the output file is empty, no files were hashed
if [ ! -s "$OUTPUT_FILE" ]; then
    log_error "❌ Error: No valid files were found to hash."
    exit 1
fi

log_success "🚀 Checksums saved to $OUTPUT_FILE"