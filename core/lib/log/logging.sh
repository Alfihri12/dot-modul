#!/usr/bin/env bash

if [[ "${LOGGING_LOADED:-0}" == "1" ]]; then
    return 0 2>/dev/null || exit 0
fi

_log_color() {
    local scope="$1"
    local level="$2"

    case "$scope" in
        pkg) printf '\033[1;32m' ;;
        symlink) printf '\033[1;34m' ;;
        service) printf '\033[1;35m' ;;
        *)
            case "$level" in
                INFO) printf '\033[1;37m' ;;
                WARN) printf '\033[1;33m' ;;
                ERROR) printf '\033[1;31m' ;;
                DEBUG) printf '\033[1;36m' ;;
                *) printf '\033[0m' ;;
            esac
            ;;
    esac
}

log_init() {
    local log_root

    log_root="${DOTFILES_DIR:-$(pwd)}"
    LOG_FILE="${LOG_FILE:-${log_root}/install.log}"

    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
}

log_set_module() {
    local module_name="${1:-}"

    [[ -n "$module_name" ]] || return 1
    LOG_MODULE="$module_name"
}

log_set_scope() {
    local scope_name="${1:-}"

    [[ -n "$scope_name" ]] || return 1
    LOG_SCOPE="$scope_name"
}

log_emit() {
    local level="${1:-INFO}"
    local scope="${2:-${LOG_SCOPE:-core}}"
    shift 2 || true

    local message="$*"
    local module line color reset

    case "$level" in
        IFO) level="INFO" ;;
        INFO|WARN|ERROR|DEBUG) ;;
        *) level="INFO" ;;
    esac

    if [[ "$level" == "DEBUG" && "${SYSTEM_DEBUG:-false}" != "true" ]]; then
        return 0
    fi

    [[ -n "${LOG_FILE:-}" ]] || log_init

    module="${LOG_MODULE:-core}"
    line="[$level] [$module] [$scope] $message"

    printf '%s\n' "$line" >> "$LOG_FILE"

    color="$(_log_color "$scope" "$level")"
    reset=$'\033[0m'

    if [[ "$level" == "ERROR" ]]; then
        if [[ -t 2 ]]; then
            printf '%b%s%b\n' "$color" "$line" "$reset" >&2
        else
            printf '%s\n' "$line" >&2
        fi
        return 0
    fi

    if [[ -t 1 ]]; then
        printf '%b%s%b\n' "$color" "$line" "$reset"
    else
        printf '%s\n' "$line"
    fi
}

log_info_scope() {
    local scope="$1"
    shift || true
    log_emit "INFO" "$scope" "$*"
}

log_warn_scope() {
    local scope="$1"
    shift || true
    log_emit "WARN" "$scope" "$*"
}

log_error_scope() {
    local scope="$1"
    shift || true
    log_emit "ERROR" "$scope" "$*"
}

log_debug_scope() {
    local scope="$1"
    shift || true
    log_emit "DEBUG" "$scope" "$*"
}

log_info() {
    log_emit "INFO" "${LOG_SCOPE:-core}" "$*"
}

log_warn() {
    log_emit "WARN" "${LOG_SCOPE:-core}" "$*"
}

log_error() {
    log_emit "ERROR" "${LOG_SCOPE:-core}" "$*"
}

log_debug() {
    log_emit "DEBUG" "${LOG_SCOPE:-core}" "$*"
}

log_ifo() {
    log_info "$*"
}

log_idempotent() {
    local scope="${LOG_SCOPE:-core}"
    local message="$*"

    if (( $# > 1 )); then
        scope="$1"
        shift
        message="$*"
    fi

    log_emit "INFO" "$scope" "Idempotent skip: $message"
}

log_init
export LOGGING_LOADED=1
