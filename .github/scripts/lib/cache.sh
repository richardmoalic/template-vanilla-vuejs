#!/usr/bin/env bash
# ==========================================================
# SCRIPT: cache.sh
# PURPOSE: Secure cache management
# ==========================================================

CACHE_LIB_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$CACHE_LIB_DIR/logger.sh"

: "${CACHE_DIR:?CACHE_DIR environment variable is not initialized}"
: "${BIN_DIR:?BIN_DIR environment variable is not initialized}"

_cache_resolve() {
    local name="$1"
    local version="$2"
    local file="${3:-archive}"

    echo "$CACHE_DIR/$name/$version/$file"
}

cache_get_archive_path() {
    _cache_resolve "$1" "$2" archive
}

cache_get_binary_path() {
    _cache_resolve "$1" "$2" "$3"
}

cache_is_valid() {
    local file="$1"
    local sha="$2"

    [[ -f "$file" ]] || return 1

    printf "%s  %s\n" "$sha" "$file" \
        | sha256sum -c --status
}

cache_restore() {

    local name="$1"
    local version="$2"
    local bin_name="$3"

    local bin_path
    bin_path="$(cache_get_binary_path "$name" "$version" "$bin_name")"

    local hash_file="${bin_path}.sha256"

    [[ -x "$bin_path" ]] || return 1
    [[ -f "$hash_file" ]] || return 1

    if ! sha256sum -c "$hash_file" >/dev/null 2>&1; then

        log_error "cache" \
            "Integrity failure detected for ${name}@${version}"

        rm -f "$bin_path" "$hash_file"

        return 1
    fi

    log_success "cache" \
        "Restored ${name}@${version}"

    printf '%s\n' "$bin_path"
}

cache_store_archive() {

    local name="$1"
    local version="$2"
    local source_file="$3"

    local dest
    dest="$(cache_get_archive_path "$name" "$version")"

    mkdir -p "$(dirname "$dest")"

    cp "$source_file" "${dest}.tmp"
    mv "${dest}.tmp" "$dest"

    log_success "cache" \
        "Stored archive ${name}@${version}"
}

cache_store_binary() {

    local name="$1"
    local version="$2"
    local bin_name="$3"
    local source_bin="$4"

    local dest
    dest="$(cache_get_binary_path "$name" "$version" "$bin_name")"

    mkdir -p "$(dirname "$dest")"

    install -m 755 \
        "$source_bin" \
        "${dest}.tmp"

    sha256sum "${dest}.tmp" \
        > "${dest}.tmp.sha256"

    mv "${dest}.tmp" "$dest"
    mv "${dest}.tmp.sha256" "${dest}.sha256"

    log_success "cache" \
        "Stored binary ${name}@${version}"
}

cache_cleanup() {

    local days="${CACHE_MAX_AGE_DAYS:-30}"

    log_info "cache" "Pruning elements inside CACHE_DIR older than ${days} days"

    find "$CACHE_DIR" \
        -type f \
        -mtime +"$days" \
        -delete || true

    find "$CACHE_DIR" \
        -type d \
        -empty \
        -delete || true
}