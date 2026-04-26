#!/usr/bin/env bash

module_runner_fail() {
    log_error "$1"
    return 1
}

run_module() {
    local module_dir="$1"
    local module_name
    local previous_log_module="${LOG_MODULE:-runner}"

    LOG_MODULE="runner"

    if [[ -z "$module_dir" ]]; then
        module_runner_fail "run_module requires module_dir"
        LOG_MODULE="$previous_log_module"
        return 1
    fi

    if [[ ! -d "$module_dir" ]]; then
        module_runner_fail "module directory not found: $module_dir"
        LOG_MODULE="$previous_log_module"
        return 1
    fi

    module_name="$(basename "$module_dir")"
    LOG_MODULE="$module_name"
    if ! module_load_context "$module_name"; then
        LOG_MODULE="$previous_log_module"
        return 1
    fi

    log_info "setting up module"

    if declare -F module_before_run >/dev/null; then
        log_debug "running module_before_run hook"
        module_before_run
    fi

    if ((${#MODULE_PACKAGES[@]} > 0)); then
        install_pkgs "${MODULE_PACKAGES[@]}"
    fi

    if ((${#MODULE_AUR_PACKAGES[@]} > 0)); then
        install_aur_pkgs "${MODULE_AUR_PACKAGES[@]}"
    fi

    if ((${#MODULE_SYSTEM_SERVICES[@]} > 0)); then
        enable_services "${MODULE_SYSTEM_SERVICES[@]}"
    fi

    if ((${#MODULE_USER_SERVICES[@]} > 0)); then
        enable_user_services "${MODULE_USER_SERVICES[@]}"
    fi

    link_module_configs "$MODULE_DIR" "$MODULE_CONFIG_DIR"

    if declare -F module_after_run >/dev/null; then
        log_debug "running module_after_run hook"
        module_after_run
    fi

    log_info "module completed"
    LOG_MODULE="$previous_log_module"
}
