#!/usr/bin/env bash

unlink_path() {
    local src="$1"
    local dst="$2"
    local current_target

    if [[ ! -L "$dst" ]]; then
        if [[ -e "$dst" ]]; then
            log_warn_scope "symlink" "target is not a symlink, skipping unlink: $dst"
        else
            log_idempotent "symlink" "symlink already absent: $dst"
        fi
        return 0
    fi

    current_target="$(readlink "$dst")"

    if [[ "$current_target" != "$src" ]]; then
        log_warn_scope "symlink" "symlink target differs, skipping unlink: $dst -> $current_target"
        return 0
    fi

    rm -f "$dst"
    log_info_scope "symlink" "Unlinked $dst"
}

unlink_module_configs() {
    local module_dir="$1"
    local module_config_dir="${2:-$module_dir/config}"
    local config_entry
    local config_name
    local target_path
    local found_config=0

    if [[ ! -d "$module_config_dir" ]]; then
        log_warn_scope "symlink" "module config directory not found: $module_config_dir"
        return 0
    fi

    mkdir -p "$XDG_CONFIG_HOME"

    while IFS= read -r -d '' config_entry; do
        found_config=1
        config_name="$(basename "$config_entry")"
        target_path="${XDG_CONFIG_HOME}/${config_name}"
        unlink_path "$config_entry" "$target_path"
    done < <(find "$module_config_dir" -mindepth 1 -maxdepth 1 -print0 | sort -z)

    if [[ "$found_config" -eq 0 ]]; then
        log_warn_scope "symlink" "no configuration entries to unlink: $module_config_dir"
    fi
}

module_unlink() {
    local module_name="$1"
    local previous_log_module="${LOG_MODULE:-modulectl}"

    module_load_context "$module_name" || return 1
    LOG_MODULE="$MODULE_NAME"

    unlink_module_configs "$MODULE_DIR" "$MODULE_CONFIG_DIR"

    LOG_MODULE="$previous_log_module"
}
