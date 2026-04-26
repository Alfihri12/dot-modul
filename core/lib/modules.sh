#!/usr/bin/env bash

module_state_dir() {
    printf '%s\n' "${XDG_STATE_HOME}/dot-modul"
}

module_disabled_file() {
    printf '%s\n' "$(module_state_dir)/disabled-modules"
}

ensure_module_state_file() {
    local state_dir
    local disabled_file

    state_dir="$(module_state_dir)"
    disabled_file="$(module_disabled_file)"

    mkdir -p "$state_dir"
    [[ -f "$disabled_file" ]] || : > "$disabled_file"
}

module_dir_for_name() {
    local module_name="$1"
    local module_dir

    [[ -n "$module_name" ]] || return 1
    [[ "$module_name" != _* ]] || return 1

    module_dir="${MODULES_DIR}/${module_name}"

    [[ -d "$module_dir" ]] || return 1
    [[ -f "${module_dir}/module.conf" ]] || return 1

    printf '%s\n' "$module_dir"
}

module_exists() {
    module_dir_for_name "${1:-}" >/dev/null
}

module_reset_runtime_context() {
    MODULE_PACKAGES=()
    MODULE_AUR_PACKAGES=()
    MODULE_SYSTEM_SERVICES=()
    MODULE_USER_SERVICES=()

    unset -f module_before_run 2>/dev/null || true
    unset -f module_after_run 2>/dev/null || true
}

module_load_context() {
    local module_name="$1"
    local module_dir

    module_dir="$(module_dir_for_name "$module_name")" || {
        log_error_scope "module" "module not found: $module_name"
        return 1
    }

    MODULE_DIR="$module_dir"
    MODULE_NAME="$module_name"
    MODULE_CONFIG_FILE="${MODULE_DIR}/module.conf"
    MODULE_CONFIG_DIR="${MODULE_DIR}/config"
    MODULE_CUSTOM_FILE="${MODULE_DIR}/custom.sh"

    module_reset_runtime_context

    source "$MODULE_CONFIG_FILE"

    if [[ -f "$MODULE_CUSTOM_FILE" ]]; then
        source "$MODULE_CUSTOM_FILE"
    fi
}

module_list_all() {
    local module_dir
    local module_name

    while IFS= read -r -d '' module_dir; do
        module_name="$(basename "$module_dir")"

        [[ "$module_name" == _* ]] && continue
        [[ -f "${module_dir}/module.conf" ]] || continue

        printf '%s\n' "$module_name"
    done < <(find "$MODULES_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
}

module_collect_all() {
    local -n modules_ref="$1"

    mapfile -t modules_ref < <(module_list_all)
}

module_is_enabled() {
    local module_name="$1"
    local disabled_file

    module_exists "$module_name" || return 1

    ensure_module_state_file
    disabled_file="$(module_disabled_file)"

    ! grep -Fxq -- "$module_name" "$disabled_file"
}

module_collect_enabled() {
    local -n modules_ref="$1"
    local all_modules=()
    local module_name

    module_collect_all all_modules
    modules_ref=()

    for module_name in "${all_modules[@]}"; do
        if module_is_enabled "$module_name"; then
            modules_ref+=("$module_name")
        fi
    done
}

module_collect_disabled() {
    local -n modules_ref="$1"
    local all_modules=()
    local module_name

    module_collect_all all_modules
    modules_ref=()

    for module_name in "${all_modules[@]}"; do
        if ! module_is_enabled "$module_name"; then
            modules_ref+=("$module_name")
        fi
    done
}

module_list_contains() {
    local needle="$1"
    shift || true

    local item

    for item in "$@"; do
        [[ "$item" == "$needle" ]] && return 0
    done

    return 1
}

module_disable() {
    local module_name="$1"
    local disabled_file

    if ! module_exists "$module_name"; then
        log_error_scope "module" "module not found: $module_name"
        return 1
    fi

    ensure_module_state_file
    disabled_file="$(module_disabled_file)"

    if ! module_is_enabled "$module_name"; then
        log_idempotent "module" "module already disabled: $module_name"
        return 0
    fi

    printf '%s\n' "$module_name" >> "$disabled_file"
    sort -u -o "$disabled_file" "$disabled_file"

    log_info_scope "module" "module disabled: $module_name"
}

module_enable() {
    local module_name="$1"
    local disabled_file
    local temp_file

    if ! module_exists "$module_name"; then
        log_error_scope "module" "module not found: $module_name"
        return 1
    fi

    ensure_module_state_file
    disabled_file="$(module_disabled_file)"

    if module_is_enabled "$module_name"; then
        log_idempotent "module" "module already enabled: $module_name"
        return 0
    fi

    temp_file="$(mktemp "${TMPDIR:-/tmp}/dot-modul-disabled.XXXXXX")"
    grep -Fxv -- "$module_name" "$disabled_file" > "$temp_file" || true
    mv "$temp_file" "$disabled_file"

    log_info_scope "module" "module enabled: $module_name"
}

module_parse_selection() {
    local raw_selection="$1"
    local -n selection_out_ref="$2"
    local enabled_modules=()
    local normalized_selection
    local tokens=()
    local token
    local module_name
    local index

    module_collect_enabled enabled_modules
    selection_out_ref=()

    if ((${#enabled_modules[@]} == 0)); then
        return 0
    fi

    normalized_selection="${raw_selection//,/ }"

    if [[ -z "${normalized_selection//[[:space:]]/}" ]]; then
        selection_out_ref=("${enabled_modules[@]}")
        return 0
    fi

    read -r -a tokens <<< "$normalized_selection"

    if ((${#tokens[@]} == 1)) && [[ "${tokens[0],,}" == "all" ]]; then
        selection_out_ref=("${enabled_modules[@]}")
        return 0
    fi

    for token in "${tokens[@]}"; do
        if [[ "$token" =~ ^[0-9]+$ ]]; then
            index=$((token - 1))

            if ((index < 0 || index >= ${#enabled_modules[@]})); then
                log_error_scope "module" "module index out of range: $token"
                return 1
            fi

            module_name="${enabled_modules[$index]}"
        else
            module_name="$token"

            if ! module_exists "$module_name"; then
                log_error_scope "module" "module not found: $module_name"
                return 1
            fi

            if ! module_is_enabled "$module_name"; then
                log_error_scope "module" "module is disabled: $module_name"
                return 1
            fi
        fi

        if ! module_list_contains "$module_name" "${selection_out_ref[@]}"; then
            selection_out_ref+=("$module_name")
        fi
    done
}
