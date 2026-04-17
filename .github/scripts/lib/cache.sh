#!/usr/bin/env bash
# ==========================================================
# SCRIPT: cache.sh
# VERSION: v1.0.0
# ==========================================================

CACHE_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$CACHE_SCRIPT_DIR/core.sh"
source "$CACHE_SCRIPT_DIR/logger.sh"

cache_get_path() {
  echo "${CACHE_DIR}/$1/$2/archive"
}

cache_get_bin_path() {
  echo "${CACHE_DIR}/$1/$2/$3"
}

cache_is_valid() {
  local file="$1" sha="$2"
  [ -f "$file" ] || return 1
  log_info "cache" "Validating checksum for $(basename "$file")"
  printf "%s  %s\n" "$sha" "$file" | sha256sum -c --status
}

cache_restore() {
   local name="$1" version="$2" bin_name="$3"
  local bin_path
  bin_path="$(cache_get_bin_path "$name" "$version" "$bin_name")"

  if [ -x "$bin_path" ]; then
    log_success "cache" "Restored ${name}@${version} from cache"
    echo "$bin_path"
    return 0
  fi

  return 1
}

cache_store_archive() {
  local name="$1" version="$2" tmp_file="$3"
  local dest
  dest="$(cache_get_path "$name" "$version")"

  mkdir -p "$(dirname "$dest")"

  # atomic write
  cp "$tmp_file" "${dest}.tmp"
  mv "${dest}.tmp" "$dest"

  log_success "cache" "Stored archive ${name}@${version}"
}

cache_store_binary() {
  local name="$1" version="$2" bin_name="$3" source_bin="$4"
  local dest
  dest="$(cache_get_bin_path "$name" "$version" "$bin_name")"

  mkdir -p "$(dirname "$dest")"

  cp "$source_bin" "${dest}.tmp"
  chmod +x "${dest}.tmp"
  mv "${dest}.tmp" "$dest"

  log_success "cache" "Stored binary ${name}@${version}"
}



cache_cleanup() {
  local max_age_days="${CACHE_MAX_AGE_DAYS:-30}"
  
  log_info "cache" "Cleaning cache older than ${max_age_days} days"
  find "$CACHE_DIR" -type f -name "archive" -mtime "+$max_age_days" -delete || true
  find "$CACHE_DIR" -type d -empty -delete || true
}