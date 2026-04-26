#!/usr/bin/env bash

if [[ "${BOOTSTRAP_LOADED:-0}" == "1" ]]; then
    return 0 2>/dev/null || exit 0
fi

bootstrap_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
bootstrap_env="${bootstrap_root}/core/env/core.env"
bootstrap_lib_dir="${bootstrap_root}/core/lib"
bootstrap_run="${bootstrap_root}/core/run.sh"

bootstrap_fallback_log() {
    local level="$1"
    shift || true
    local message="$*"
    local line

    line="[$level] [bootstrap] [core] $message"

    printf '%s\n' "$line" >&2
    printf '%s\n' "$line" >> "${bootstrap_root}/install.log"
}

if [[ ! -f "$bootstrap_env" ]]; then
    bootstrap_fallback_log "ERROR" "core environment file not found: $bootstrap_env"
    return 1 2>/dev/null || exit 1
fi

source "$bootstrap_env"
source "${bootstrap_lib_dir}/log/logging.sh"
log_set_module "bootstrap"

if [[ ! -f "$bootstrap_run" ]]; then
    log_error "core runner not found: $bootstrap_run"
    return 1 2>/dev/null || exit 1
fi

while IFS= read -r -d '' bootstrap_lib; do
    source "$bootstrap_lib"
done < <(find "$bootstrap_lib_dir" -type f -print0 | sort -z)

source "$bootstrap_run"

for required_var in DOTFILES_DIR MODULES_DIR XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME; do
    if [[ -z "${!required_var:-}" ]]; then
        log_error "bootstrap variable is empty: $required_var"
        return 1 2>/dev/null || exit 1
    fi
done

if [[ ! -d "$MODULES_DIR" ]]; then
    log_error "modules directory not found: $MODULES_DIR"
    return 1 2>/dev/null || exit 1
fi

if ! declare -F run_module >/dev/null; then
    log_error "module runner is unavailable after bootstrap"
    return 1 2>/dev/null || exit 1
fi

log_debug "bootstrap validation completed"
export BOOTSTRAP_LOADED=1
