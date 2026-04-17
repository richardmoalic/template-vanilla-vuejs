#!/usr/bin/env bash
# ==========================================================
# SCRIPT: clear-cache.sh
# PURPOSE: Remove cached binaries and temporary files
# ==========================================================
set -euo pipefail

CACHE_DIR="${HOME}/.cache/dev-tools"
BIN_DIR="${HOME}/.local/bin"

echo "🧹 Cleaning Dev Tools Cache..."

if [ -d "$CACHE_DIR" ]; then
    rm -rf "${CACHE_DIR:?}"/*
    echo "✅ Cache directory cleared: $CACHE_DIR"
else
    echo "ℹ️ No cache directory found."
fi

# Optional: Clean the local binaries too
read -p "❓ Do you want to remove installed binaries in $BIN_DIR too? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f "$BIN_DIR/cosign" "$BIN_DIR/gitleaks" "$BIN_DIR/trufflehog" "$BIN_DIR/infisical"
    echo "✅ Binaries removed."
fi

echo "✨ Workspace is clean."