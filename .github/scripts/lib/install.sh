#!/usr/bin/env bash
# ==========================================================
# SCRIPT: install.sh
# PURPOSE: Secure tool installation
# ==========================================================

INSTALL_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$INSTALL_SCRIPT_DIR/core.sh"
source "$INSTALL_SCRIPT_DIR/cache.sh"
source "$INSTALL_SCRIPT_DIR/logger.sh"
source "$INSTALL_SCRIPT_DIR/download-file.sh"
source "$INSTALL_SCRIPT_DIR/verify-download.sh"
source "$INSTALL_SCRIPT_DIR/extract-download.sh"

core_init

_install_extract() {

    local type="$1"
    local archive="$2"
    local bin_name="$3"

    case "$type" in
        tar)
            _ext_tar "$archive" "$BIN_DIR" "$bin_name"
            ;;
        zip)
            _ext_zip "$archive" "$BIN_DIR" "$bin_name"
            ;;
        binary)
            _ext_bin "$archive" "$BIN_DIR" "$bin_name"
            ;;
        *)
            fail "Unsupported archive type: $type"
            ;;
    esac
}

_validate_binary() {

    local name="$1"
    local binary="$2"

    [[ -x "$binary" ]] || \
        fail "$name installation failed (not executable)"

    if ! "$binary" --version >/dev/null 2>&1; then

        if ! "$binary" version >/dev/null 2>&1; then
            log_warn "$name" \
                "Runtime version validation failed"
        fi
    fi
}

install_tool() {

    local name="$1"
    local version="$2"
    local url="$3"
    local sha="$4"
    local type="$5"
    local bin_name="$6"

    local target_bin="$BIN_DIR/$bin_name"

    log_group_start "Installing ${name} ${version}"

    # --------------------------------------------------
    # Local install
    # --------------------------------------------------

    if [[ -x "$target_bin" ]]; then

        log_info "$name" \
            "Already installed"

        log_group_end
        return 0
    fi

    # --------------------------------------------------
    # Binary cache
    # --------------------------------------------------

    local cached_bin

    if cached_bin="$(cache_restore "$name" "$version" "$bin_name")"; then

        install -m 755 \
            "$cached_bin" \
            "$target_bin"

        log_success "$name" \
            "Restored from cache"

        log_group_end
        return 0
    fi

    # --------------------------------------------------
    # Archive cache
    # --------------------------------------------------

    local archive
    archive="$(cache_get_archive_path "$name" "$version")"

    local target_archive=""

    if cache_is_valid "$archive" "$sha"; then

        log_info "$name" \
            "Using cached archive"

        target_archive="$archive"

    else

        log_info "$name" \
            "Downloading"

        local tmp_file
        tmp_file="$(mktemp)"

        trap 'rm -f "$tmp_file"' RETURN

        download_file "$url" "$tmp_file"

        verify_file \
            "$url" \
            "$tmp_file" \
            "$sha"

        if [[ "$DRY_RUN" != "true" ]]; then

            cache_store_archive \
                "$name" \
                "$version" \
                "$tmp_file"

            target_archive="$(
                cache_get_archive_path \
                    "$name" \
                    "$version"
            )"

        else

            target_archive="$tmp_file"
        fi
    fi

    # --------------------------------------------------
    # Extraction
    # --------------------------------------------------

    log_step "$name" "Extracting"

    _install_extract \
        "$type" \
        "$target_archive" \
        "$bin_name"

    # --------------------------------------------------
    # Validation
    # --------------------------------------------------

    _validate_binary \
        "$name" \
        "$target_bin"

    # --------------------------------------------------
    # Binary cache
    # --------------------------------------------------

    cache_store_binary \
        "$name" \
        "$version" \
        "$bin_name" \
        "$target_bin"

    log_success "$name" \
        "Installed successfully"

    log_group_end
}