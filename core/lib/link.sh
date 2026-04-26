#!/usr/bin/env bash

link_path() {
    local src="$1"
    local dst="$2"
    local current_target
    local backup_path

    if [[ ! -e "$src" && ! -L "$src" ]]; then
        log_error_scope "symlink" "link source not found: $src"
        return 1
    fi

    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" ]]; then
        current_target="$(readlink "$dst")"
        if [[ "$current_target" == "$src" ]]; then
            log_idempotent "symlink" "symlink is already correct: $dst"
            return 0
        fi

        rm -f "$dst"
    elif [[ -e "$dst" ]]; then
        backup_path="${dst}.bak.$(date +%s)"
        mv "$dst" "$backup_path"
        log_warn_scope "symlink" "existing target backed up: $dst -> $backup_path"
    fi

    ln -s "$src" "$dst"
    log_info_scope "symlink" "Linking $dst -> $src"
}

link_module_configs() {
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
        link_path "$config_entry" "$target_path"
    done < <(find "$module_config_dir" -mindepth 1 -maxdepth 1 -print0 | sort -z)

    if [[ "$found_config" -eq 0 ]]; then
        log_warn_scope "symlink" "no configuration entries to link: $module_config_dir"
    fi
}
