#!/usr/bin/env bash

remove_pkg() {
    local pkg="$1"

    if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
        log_idempotent "pkg" "package already absent: $pkg"
        return 0
    fi

    log_info_scope "pkg" "Removing $pkg"
    sudo pacman -Rns --noconfirm "$pkg"
}

remove_pkgs() {
    local pkg

    for pkg in "$@"; do
        remove_pkg "$pkg"
    done
}

remove_aur() {
    local pkg="$1"

    if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
        log_idempotent "pkg" "AUR package already absent: $pkg"
        return 0
    fi

    log_info_scope "pkg" "Removing AUR package $pkg"
    sudo pacman -Rns --noconfirm "$pkg"
}

remove_aur_pkgs() {
    local pkg

    for pkg in "$@"; do
        remove_aur "$pkg"
    done
}

module_uninstall() {
    local module_name="$1"
    local previous_log_module="${LOG_MODULE:-modulectl}"
    local has_actions=0

    module_load_context "$module_name" || return 1
    LOG_MODULE="$MODULE_NAME"

    if ((${#MODULE_SYSTEM_SERVICES[@]} > 0)); then
        disable_services "${MODULE_SYSTEM_SERVICES[@]}"
        has_actions=1
    fi

    if ((${#MODULE_USER_SERVICES[@]} > 0)); then
        disable_user_services "${MODULE_USER_SERVICES[@]}"
        has_actions=1
    fi

    if ((${#MODULE_PACKAGES[@]} > 0)); then
        remove_pkgs "${MODULE_PACKAGES[@]}"
        has_actions=1
    fi

    if ((${#MODULE_AUR_PACKAGES[@]} > 0)); then
        remove_aur_pkgs "${MODULE_AUR_PACKAGES[@]}"
        has_actions=1
    fi

    if ((has_actions == 0)); then
        log_idempotent "pkg" "no services or packages defined for module: $module_name"
    fi

    LOG_MODULE="$previous_log_module"
}
