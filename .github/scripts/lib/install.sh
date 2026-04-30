#!/usr/bin/env bash
# ==========================================================
# SCRIPT: install.sh
# PURPOSE:
#
# FEATURES:
#
# USAGE:
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
    return 0
  fi

  # -------------------------------
  # 2. Restore binary from cache
  # -------------------------------
  local cached_bin
  if cached_bin="$(cache_restore "$name" "$version" "$bin_name")"; then
    run "Restoring $name from cache" cp "$cached_bin" "$target_bin"
    run "Setting permissions" chmod +x "$target_bin"
    return 0
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

    (
      tmp_file="$(mktemp)"
      trap 'rm -f "$tmp_file"' EXIT

      download_file "$url" "$tmp_file"
      verify_file "$url" "$tmp_file" "$sha"

      if [ "$DRY_RUN" != "true" ]; then
        cache_store_archive "$name" "$version" "$tmp_file"
        target="$(cache_get_path "$name" "$version")"
      else
        target="$tmp_file"
      fi

      # extraction happens outside subshell
      echo "$target" > /tmp/.install_target
    )

    target="$(cat /tmp/.install_target)"
    rm -f /tmp/.install_target
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