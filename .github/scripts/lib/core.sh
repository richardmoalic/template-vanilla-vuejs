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
source "$CORE_SCRIPT_DIR/../cache/cache-vars.sh"

# -------------------------------
# Config
# -------------------------------
: "${DRY_RUN:=false}"
: "${TRACE:=false}"
: "${LOG_FORMAT:=text}"

# Workspace-aware defaults
WORKSPACE_ROOT="${GITHUB_WORKSPACE:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"

: "${TOOLS_DIR:=${WORKSPACE_ROOT}/.github/tools}"
: "${CACHE_DIR:=${TOOLS_DIR}/cache}"
: "${BIN_DIR:=${TOOLS_DIR}/bin}"

readonly WORKSPACE_ROOT
readonly TOOLS_DIR
readonly CACHE_DIR
readonly BIN_DIR

now_ms() {
  date +%s%3N
}

run() {
  local msg="$1"
  shift
  local cmd=("$@")

  log_start "run" "$msg"

  if [ "${DRY_RUN:-false}" = "true" ]; then
    log_info "run" "[dry-run] ${cmd[*]}"
    return 0
  fi

  local start end status
  start=$(now_ms)

  if "${cmd[@]}"; then
      status=0
  else
      status=$?
  fi

  end=$(now_ms)
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

  cache_init
  mkdir -p "$CACHE_DIR" "$BIN_DIR"

  case ":$PATH:" in
    *":$BIN_DIR:"*) ;; # already in PATH
    *) export PATH="$BIN_DIR:$PATH" ;;
  esac

  log_debug "core" "Initialized (CACHE_DIR=$CACHE_DIR, BIN_DIR=$BIN_DIR)"
}

ensure_file() {
  local name="$1" version="$2" url="$3" sha="$4" type="$5" bin_name="$6"
  local local_bin="$BIN_DIR/$bin_name"

  if [ -x "$local_bin" ]; then
    log_info "$name" "Verified local version exists."
    return 0
  fi

  if command -v "$bin_name" &>/dev/null; then
    log_warn "$name" "Found in system PATH, but NOT our verified version. Installing project-local binary..."
  fi

  install_tool "$name" "$version" "$url" "$sha" "$type" "$bin_name"
}

fail() {

    local message="${1:-Unknown failure}"
    local exit_code="${2:-1}"

    log_error "fatal" "$message"

    exit "$exit_code"
}