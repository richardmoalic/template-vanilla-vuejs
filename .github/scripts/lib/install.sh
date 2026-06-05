#!/usr/bin/env bash
# ==========================================================
# SCRIPT: install.sh
# PURPOSE: Install a tool
#
# FEATURES:
#
# USAGE:
#   install_tool <name> <version> <url> <sha256> <type> <bin_name>
#
# Types:
#   - tar   : Archive that needs extraction
#   - binary: Direct binary download (no extraction)
#   - zip   : Zip archive that needs extraction
# -------------------------------
#
# VERSION: v1.0.0
# ==========================================================

INSTALL_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$INSTALL_SCRIPT_DIR/core.sh"
source "$INSTALL_SCRIPT_DIR/cache.sh"
source "$INSTALL_SCRIPT_DIR/download-file.sh"
source "$INSTALL_SCRIPT_DIR/logger.sh"
source "$INSTALL_SCRIPT_DIR/verify-download.sh"
source "$INSTALL_SCRIPT_DIR/extract-download.sh"

core_init

install_tool() {
  

  local name="$1" version="$2" url="$3" sha="$4" type="$5" bin_name="$6"
  local target_bin="$BIN_DIR/$bin_name"

  log_group_start "Installing $name Version: $version"

  # -------------------------------
  # 1. Already installed (local bin)
  # -------------------------------
  if [ -x "$target_bin" ]; then
    log_info "$name" "Already installed → skipping"
    log_group_end
    return 0
  fi

  # -------------------------------
  # 2. Restore binary from cache
  # -------------------------------
  local cached_bin
  if cached_bin="$(cache_restore "$name" "$version" "$bin_name")"; then
    if verify_hash "$cached_bin" "$sha"; then
      run "Restoring $name from cache" cp "$cached_bin" "$target_bin"
      run "Setting permissions" chmod +x "$target_bin"
      log_success "$name" "Restored from cache"
      log_group_end
      return 0
      else
       log_warn "$name" "Cache corrupted! Re-downloading..."
       rm -f "$cached_bin"
    fi
  fi

  # -------------------------------
  # 3. Resolve archive
  # -------------------------------
  local archive
  archive="$(cache_get_path "$name" "$version")"

  local target=""

  if cache_is_valid "$archive" "$sha"; then
    log_info "$name" "Using cached archive"
    target="$archive"
  else
    log_warn "$name" "Cache miss → downloading"

    local tmp_file
    tmp_file="$(mktemp)"

      download_file "$url" "$tmp_file"
      verify_file "$url" "$tmp_file" "$sha"

      if [ "$DRY_RUN" != "true" ]; then
        cache_store_archive "$name" "$version" "$tmp_file"
        target="$(cache_get_path "$name" "$version")"
        rm -f "$tmp_file"
      else
        target="$tmp_file"
      fi
    fi

  # -------------------------------
  # 4. Extract
  # -------------------------------
  log_step "$name" "Extracting"

  case "$type" in
    tar)    _ext_tar "$target" "$BIN_DIR" "$bin_name" ;;
    binary) _ext_bin "$target" "$BIN_DIR" "$bin_name" ;;
    zip)    _ext_zip "$target" "$BIN_DIR" "$bin_name" ;;
    *)      fail "Unsupported archive type: $type" ;;
  esac

  # -------------------------------
  # 5. Validate binary (basic)
  # -------------------------------
  if ! [ -x "$target_bin" ]; then
    fail "$name installation failed (binary not executable)"
  fi

  # Runtime validation
  if ! "$target_bin" --version >/dev/null 2>&1; then
    log_warn "$name" "Binary installed but version check failed"
  fi

  # -------------------------------
  # 6. Cache extracted binary
  # -------------------------------
  cache_store_binary "$name" "$version" "$bin_name" "$target_bin"

  log_success "$name" "Installed successfully"
  log_group_end
}