#!/usr/bin/env bash

# ==========================================================
# SCRIPT: extract-download.sh
# VERSION: v3.0.0
# ==========================================================

# Specialized extraction helpers
_ext_tar() {
  local archive="$1"
  local dest="$2"
  local bin_name="$3"

  local tmp_dir
  tmp_dir="$(mktemp -d)"

  tar -xzf "$archive" -C "$tmp_dir"

  # find binary inside archive
  local found
  found="$(find "$tmp_dir" -type f -name "$bin_name" -perm -111 | head -n1)"

  if [ -z "$found" ]; then
    fail "Binary $bin_name not found in archive"
  fi

  cp "$found" "$dest/$bin_name"
  chmod +x "$dest/$bin_name"

  rm -rf "$tmp_dir"
}

_ext_bin() { local file="$1"
  local dest="$2"
  local bin_name="$3"

  cp "$file" "$dest/$bin_name"
  chmod +x "$dest/$bin_name"
  } 

_ext_zip() { 
  local archive="$1"
  local dest="$2"
  local bin_name="$3"

  unzip -qj "$archive" "$bin_name" -d "$dest"
  chmod +x "$dest/$bin_name"
   }