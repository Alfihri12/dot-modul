#!/usr/bin/env bash

set -Eeuo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${DOTFILES_DIR}/core/env/core.env"
source "${DOTFILES_DIR}/core/lib/log/logging.sh"
log_set_module "modulectl"
source "${DOTFILES_DIR}/core/init/bootstrap.sh"
log_set_module "modulectl"

print_usage() {
    cat <<'EOF'
Usage: ./module.sh <command> [module...]

Commands:
  list                 Show all detected modules and their status
  status               Alias for list
  enable <module...>   Enable one or more modules
  disable <module...>  Disable modules, with optional unlink and uninstall prompts
  help, --help         Show this help

Examples:
  ./module.sh list
  ./module.sh disable waybar
  ./module.sh enable hyprland waybar
EOF
}

print_module_list() {
    local all_modules=()
    local module_name
    local state

    module_collect_all all_modules

    if ((${#all_modules[@]} == 0)); then
        printf 'No modules found in %s\n' "$MODULES_DIR"
        return 0
    fi

    printf 'Detected modules in %s:\n' "$MODULES_DIR"

    for module_name in "${all_modules[@]}"; do
        state="disabled"

        if module_is_enabled "$module_name"; then
            state="enabled"
        fi

        printf '  - %-20s [%s]\n' "$module_name" "$state"
    done
}

prompt_yes_no() {
    local prompt="$1"
    local answer
    local normalized_answer

    while true; do
        read -r -p "$prompt" answer || return 1
        normalized_answer="${answer//[[:space:]]/}"
        normalized_answer="${normalized_answer,,}"

        case "$normalized_answer" in
            y|yes|ya|iya)
                return 0
                ;;
            ""|n|no|t|tidak|ga|gak|nggak|enggak)
                return 1
                ;;
        esac

        printf 'Please answer y or n.\n'
    done
}

handle_module_disable_post_actions() {
    local module_name="$1"

    if [[ ! -t 0 || ! -t 1 ]]; then
        log_info "module disabled without unlink/uninstall prompt because the shell is non-interactive: $module_name"
        return 0
    fi

    if ! prompt_yes_no "Unlink config untuk module '$module_name'? [y/N]: "; then
        return 0
    fi

    module_unlink "$module_name"

    if prompt_yes_no "Uninstall aplikasi/paket untuk module '$module_name'? [y/N]: "; then
        module_uninstall "$module_name"
    fi
}

disable_module_workflow() {
    local module_name="$1"
    local was_enabled=0

    if ! module_exists "$module_name"; then
        log_error_scope "module" "module not found: $module_name"
        return 1
    fi

    if module_is_enabled "$module_name"; then
        was_enabled=1
    fi

    module_disable "$module_name"

    if ((was_enabled == 0)); then
        return 0
    fi

    handle_module_disable_post_actions "$module_name"
}

command_name="${1:-list}"
shift || true

case "$command_name" in
    list|status)
        print_module_list
        ;;
    enable)
        if (($# == 0)); then
            log_error "enable requires at least one module name"
            print_usage
            exit 1
        fi

        for module_name in "$@"; do
            module_enable "$module_name"
        done
        ;;
    disable)
        if (($# == 0)); then
            log_error "disable requires at least one module name"
            print_usage
            exit 1
        fi

        for module_name in "$@"; do
            disable_module_workflow "$module_name"
        done
        ;;
    help|-h|--help)
        print_usage
        ;;
    *)
        log_error "unknown command: $command_name"
        print_usage
        exit 1
        ;;
esac
