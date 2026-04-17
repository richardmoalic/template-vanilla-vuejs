#!/usr/bin/env bash

# ==========================================================
# SCRIPT: logger.sh
# PURPOSE:
# VERSION: v1.0.0
# ==========================================================

LOG_LEVEL="${LOG_LEVEL:-info}"

# -------------------------------
# Environment detection
# -------------------------------
IS_GITHUB="${GITHUB_ACTIONS:-false}"
IS_ACT="${ACT:-false}"

# -------------------------------
# Config
# -------------------------------
LOG_USE_COLOR="${LOG_USE_COLOR:-true}"
LOG_USE_EMOJI="${LOG_USE_EMOJI:-true}"

# Disable color if not TTY
if [ ! -t 1 ]; then
  LOG_USE_COLOR=false
fi

# -------------------------------
# Colors
# -------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# -------------------------------
# Emoji map (toggleable)
# -------------------------------
emoji() {
  [ "$LOG_USE_EMOJI" = "true" ] && printf "%s" "$1" || printf ""
}

# -------------------------------
# Color wrapper
# -------------------------------
color() {
  local color="$1"
  local text="$2"

  if [ "$LOG_USE_COLOR" = "true" ]; then
    printf "%b%s%b" "$color" "$text" "$NC"
  else
    printf "%s" "$text"
  fi
}

log() {
  echo "[$1] ${*:2}"
}

# -------------------------------
# Core formatter (THE KEY PIECE)
# -------------------------------
log_fmt() {
  local tool="${1:-core}"
  local msg="${2:-...}"
  local icon="${3:-}"
  local color_code="${4:-$NC}"
  local level="${5:-INFO}"

  if [[ "${LOG_FORMAT:-}" == "json" ]]; then
    printf '{"time":"%s","level":"%s","tool":"%s","msg":"%s","pid":%d}\n' \
      "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
      "$level" \
      "$tool" \
      "$msg" \
      "$$"
    return
  fi

  local tool_padded
  tool_padded=$(printf "%-10s" "$tool")

  local prefix
  prefix="$(color "$color_code" "$(emoji "$icon") [$tool_padded]")"

  printf "%s %s\n" "$prefix" "$msg" >&2
}

# -------------------------------
# Public logging API
# -------------------------------

log_info()    { 
  has_log "info" || return
  log_fmt "${1:-}" "${2:-}" "ℹ️ " "$BLUE" "INFO"
  }
log_success() { 
  log_fmt "${1:-}" "${2:-}" "✅ " "$GREEN" 
  }
log_warn()    { 
  has_log "warn" || return
  log_fmt "${1:-}" "${2:-}" "⚠️ " "$YELLOW" "WARN" 
 }
log_error()   { 
  has_log "error" || return
  log_fmt "${1:-}" "${2:-}" "❌ " "$RED" "ERROR" 
 }
log_start()   { log_fmt "${1:-}" "${2:-Starting...}" "🟦 " "$CYAN"; }
log_done()    { log_fmt "${1:-}" "${2:-Done}" "🟩 " "$GREEN"; }
log_step()    { log_fmt "${1:-}" "${2:-}" "🔹 " "$PURPLE"; }

# -------------------------------
# Group handling (smart)
# -------------------------------
log_group_start() {
  local title="$1"

  if [ "$IS_GITHUB" = "true" ] || [ "$IS_ACT" = "true" ]; then
    printf "::group::%s %s\n" "$(emoji "🚀")" "$title"
  else
    printf "\n==== %s ====\n" "$title"
  fi
}

log_group_end() {
  if [ "$IS_GITHUB" = "true" ] || [ "$IS_ACT" = "true" ]; then
    printf "::endgroup::\n"
  else
    printf "==============\n\n"
  fi
}

has_log() {
  local level="$1"

  case "$LOG_LEVEL" in
    debug) return 0 ;;
    info)  [[ "$level" != "debug" ]] ;;
    warn)  [[ "$level" == "warn" || "$level" == "error" ]] ;;
    error) [[ "$level" == "error" ]] ;;
    *) return 0 ;;
  esac
}

log_debug() {
  if has_log "debug"; then
    log_fmt "DEBUG" "$1" "$2" "🔍" "$PURPLE"
  fi
}