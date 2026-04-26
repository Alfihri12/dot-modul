#!/usr/bin/env bash

set -Eeuo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${DOTFILES_DIR}/core/env/core.env"
source "${DOTFILES_DIR}/core/lib/log/logging.sh"
log_set_module "installer"

if (( EUID == 0 )); then
    log_error "do not run installer as root"
    exit 1
fi

source "${DOTFILES_DIR}/core/init/bootstrap.sh"

print_usage() {
    cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --all                 Install all enabled modules without prompt
  --modules <list>      Install selected enabled modules
  --modules=<list>      Same as --modules
  --list-modules        Show detected modules and their status
  --no-prompt           Skip interactive prompt and install all enabled modules
  -h, --help            Show this help

Examples:
  ./install.sh
  ./install.sh --all
  ./install.sh --modules hyprland,waybar
  ./install.sh --modules "1 3"
EOF
}

print_module_status() {
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

prompt_module_selection() {
    local -n selection_ref="$1"
    local enabled_modules=()
    local disabled_modules=()
    local module_input
    local index

    module_collect_enabled enabled_modules
    module_collect_disabled disabled_modules

    if ((${#enabled_modules[@]} == 0)); then
        selection_ref=()
        return 0
    fi

    printf 'Enabled modules:\n'

    for index in "${!enabled_modules[@]}"; do
        printf '  %d. %s\n' "$((index + 1))" "${enabled_modules[$index]}"
    done

    if ((${#disabled_modules[@]} > 0)); then
        printf '\nDisabled modules:\n'

        for index in "${!disabled_modules[@]}"; do
            printf '  - %s\n' "${disabled_modules[$index]}"
        done

        printf '\nUse ./module.sh enable <module> if you want to activate a disabled module.\n'
    fi

    printf '\nType numbers or module names separated by spaces or commas.\n'
    printf 'Press Enter to install all enabled modules.\n'
    read -r -p 'Selection: ' module_input

    module_parse_selection "$module_input" "$1"
}

requested_selection=""
force_all=false
skip_prompt=false
list_modules_only=false

while (($# > 0)); do
    case "$1" in
        --all)
            force_all=true
            skip_prompt=true
            ;;
        --modules)
            if (($# < 2)); then
                log_error "--modules requires a value"
                exit 1
            fi

            requested_selection="$2"
            skip_prompt=true
            shift
            ;;
        --modules=*)
            requested_selection="${1#*=}"
            skip_prompt=true
            ;;
        --list-modules)
            list_modules_only=true
            skip_prompt=true
            ;;
        --no-prompt)
            skip_prompt=true
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            log_error "unknown argument: $1"
            print_usage
            exit 1
            ;;
    esac
    shift
done

if [[ -n "$requested_selection" && "$force_all" == true ]]; then
    log_error "use either --all or --modules, not both"
    exit 1
fi

all_modules=()
enabled_modules=()
selected_modules=()

module_collect_all all_modules
module_collect_enabled enabled_modules

if [[ "$list_modules_only" == true ]]; then
    print_module_status
    exit 0
fi

if ((${#all_modules[@]} == 0)); then
    log_warn "no modules found"
    exit 0
fi

if ((${#enabled_modules[@]} == 0)); then
    log_warn "no enabled modules available"
    exit 0
fi

if [[ "$force_all" == true ]]; then
    selected_modules=("${enabled_modules[@]}")
elif [[ -n "$requested_selection" ]]; then
    module_parse_selection "$requested_selection" selected_modules
elif [[ "$skip_prompt" != true && -t 0 && -t 1 ]]; then
    prompt_module_selection selected_modules
else
    selected_modules=("${enabled_modules[@]}")
fi

if ((${#selected_modules[@]} == 0)); then
    log_warn "no modules selected"
    exit 0
fi

log_info "selected modules: ${selected_modules[*]}"

ran_modules=0

for module_name in "${selected_modules[@]}"; do
    module_dir="$(module_dir_for_name "$module_name")"

    log_info "running module: $module_name"

    (
        set -Eeuo pipefail
        export MODULE_DIR="$module_dir"
        export MODULE_NAME="$module_name"
        export LOG_MODULE="$module_name"

        run_module "$MODULE_DIR"
    )

    ran_modules=1
done

if ((ran_modules == 0)); then
    log_warn "no modules were processed"
    exit 0
fi

wallpaper_target_dir="${HOME}/Pictures/Wallpapers"
wallpaper_source_dir="${DOTFILES_DIR}/assets/wallpapers"
screenshot_target_dir="${HOME}/Pictures/Screenshots"

mkdir -p "$wallpaper_target_dir"
mkdir -p "$screenshot_target_dir"

init_wallpapers() {
    
    if [[ ! -d "$wallpaper_source_dir" ]]; then
        log_warn "wallpaper source not found, skipping"
        return
    fi

    if [[ -n "$(ls -A "$wallpaper_target_dir" 2>/dev/null)" ]]; then
        log_info "wallpaper directory not empty, skipping initialization"
        return
    fi

    if [[ "${AUTO_INIT_WALLPAPER:-0}" == "1" ]]; then
        cp -r "$wallpaper_source_dir"/. "$wallpaper_target_dir"/
        log_info "default wallpapers initialized in $wallpaper_target_dir"
        return
    fi

    read -rp "Initialize default wallpapers? [y/N]: " ans
    case "$ans" in
        [yY]|[yY][eE][sS])
            cp -r "$wallpaper_source_dir"/. "$wallpaper_target_dir"/
            log_info "default wallpapers initialized in $wallpaper_target_dir"
            ;;
        *)
            log_info "skipped wallpaper initialization"
            ;;
    esac
}

init_wallpapers

log_info "all modules processed successfully"
log_info "wallpaper directory: $wallpaper_target_dir"
