#!/usr/bin/env bash

# ==========================================================
# SCRIPT: gitleaks.sh
# PURPOSE:
#   Helpers for scripts
# USED BY:
#   - gitleaks.sh → secrets scanning
#   - trufflehog.sh → secrets scanning
#   - install-cosign.sh → binary validation
# VERSION: v3.0.0
# ==========================================================


set -euo pipefail

if [ -n "${CORE_LIB_LOADED:-}" ]; then
  return 0
fi
readonly CORE_LIB_LOADED=1

if [[ "${TRACE:-false}" == "true" ]]; then
  export PS4='+ $(date "+%H:%M:%S") ${BASH_SOURCE}:${LINENO}: '
  set -x
fi

CORE_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$CORE_SCRIPT_DIR/logger.sh"

# -------------------------------
# Config
# -------------------------------
: "${DRY_RUN:=false}"
: "${TRACE:=false}"
: "${CACHE_DIR:=${HOME}/.cache/dev-tools}"
: "${BIN_DIR:=${HOME}/.local/bin}"
: "${LOG_FORMAT:-text}"

readonly CACHE_DIR
readonly BIN_DIR

now_ms() {
  date +%s%3N
}

run() {
  local msg="$1"
  shift
  local cmd="$*"

  log_start "run" "$msg"

  if [ "${DRY_RUN:-false}" = "true" ]; then
    log_info "run" "[dry-run] $cmd"
    return 0
  fi

  local start end status
  start=$(date +%s%3N)

  bash -c "$cmd"
  status=$?

  end=$(date +%s%3N)
  local seconds
  seconds=$(awk "BEGIN { printf \"%.2f\", ($end-$start)/1000 }")

  if [ $status -eq 0 ]; then
    log_done "run" "$msg (${seconds}s)"
  else
    log_error "run" "$msg failed (${seconds}s)"
  fi

  return $status
}


core_init() {
  mkdir -p "$CACHE_DIR" "$BIN_DIR"

  case ":$PATH:" in
    *":$BIN_DIR:"*) ;; # already in PATH
    *) export PATH="$BIN_DIR:$PATH" ;;
  esac

  log_debug "core" "Initialized (CACHE_DIR=$CACHE_DIR, BIN_DIR=$BIN_DIR)"
}

ensure_file() {
  local file="$1"
  local fallback="$2"

  if [ ! -s "$file" ]; then
    echo "$fallback" > "$file"
  fi
}