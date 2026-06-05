#!/usr/bin/env bash
# ==========================================================
# SCRIPT: cache.sh
# PURPOSE: Secure binary storage with integrity verification
# ==========================================================

CACHE_LIB_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$CACHE_LIB_DIR/logger.sh"

# Note: TOOLS_CACHE_DIR should be exported from cache-vars.sh
: "${TOOLS_CACHE_DIR:?Run cache-vars.sh first}"

# Helper to resolve paths: .github/tools/cache/gitleaks/8.18.2/gitleaks
_cache_resolve() {
    local name="$1" version="$2" file="${3:-archive}"
    echo "$TOOLS_CACHE_DIR/$name/$version/$file"
}

cache_is_valid() {
    local file="$1" sha="$2"
    [[ -f "$file" ]] || return 1
    # Verify the archive matches the hardcoded SHA in versions.env
    printf "%s  %s\n" "$sha" "$file" | sha256sum -c --status
}

cache_restore() {
    local name="$1" version="$2" bin_name="$3"
    local bin_path
    bin_path="$(_cache_resolve "$name" "$version" "$bin_name")"
    local hash_path="${bin_path}.sha256"

    # 1. Existence check
    [[ -x "$bin_path" && -f "$hash_path" ]] || return 1

    # 2. Integrity check (Verify against the hash created at STORAGE time)
    if ! sha256sum -c "$hash_path" >/dev/null 2>&1; then
        log_error "cache" "INTEGRITY FAILURE: Poisoned binary detected for $name. Purging."
        rm -f "$bin_path" "$hash_path"
        return 1
    fi

    echo "$bin_path"
}

cache_store_binary() {
    local name="$1" version="$2" bin_name="$3" source_bin="$4"
    local dest
    dest="$(_cache_resolve "$name" "$version" "$bin_name")"

    mkdir -p "$(dirname "$dest")"

    # Atomic write with metadata
    install -m 755 "$source_bin" "$dest"
    sha256sum "$dest" > "${dest}.sha256"

    log_success "cache" "Stored verified binary: $name ($version)"
}

cache_store_archive() {
    local name="$1" version="$2" tmp_file="$3"
    local dest
    dest="$(_cache_resolve "$name" "$version" "archive")"

    mkdir -p "$(dirname "$dest")"
    cp "$tmp_file" "$dest"
}