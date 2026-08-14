#!/usr/bin/env bash

ensure_yay() {
    if command -v yay >/dev/null 2>&1; then
        log_idempotent "pkg" "yay is already installed"
        return 0
    fi
    
    log_info_scope "pkg" "Installing yay dependencies"
    sudo pacman -S --needed --noconfirm base-devel git
    
    local yay_dir
    yay_dir="$(mktemp -d)"
    
    git clone https://aur.archlinux.org/yay.git "$yay_dir" || {
        log_error_scope "pkg" "Gagal clone yay! Periksa koneksi lu yang bapuk itu."
        rm -rf "$yay_dir"
        return 1
    }
    
    (
        cd "$yay_dir" && makepkg -si --noconfirm
        ) || {
        log_error_scope "pkg" "Gagal compile yay! Makepkg meledak."
        rm -rf "$yay_dir"
        return 1
    }
}

install_pkg() {
    local pkg="$1"
    
    if pacman -Qi "$pkg" >/dev/null 2>&1; then
        log_idempotent "pkg" "package already installed: $pkg"
        return 0
    fi
    
    log_info_scope "pkg" "Installing $pkg"
    sudo pacman -S --needed --noconfirm "$pkg"
}

install_pkgs() {
    local pkg
    
    for pkg in "$@"; do
        install_pkg "$pkg"
    done
}

install_aur() {
    local pkg="$1"
    
    if pacman -Qi "$pkg" >/dev/null 2>&1; then
        log_idempotent "pkg" "AUR package already installed: $pkg"
        return 0
    fi
    
    ensure_yay
    log_info_scope "pkg" "Installing AUR package $pkg"
    yay -S --needed --noconfirm "$pkg"
}

install_aur_pkgs() {
    local pkg
    
    for pkg in "$@"; do
        install_aur "$pkg"
    done
}

replace_or_add_line() {
    local text="$1"
    local file="$2"
    local key="$3"
    
    mkdir -p "$(dirname "$file")"
    [[ -f "$file" ]] || touch "$file"
    
    if grep -Fqx -- "$text" "$file"; then
        log_idempotent "pkg" "line already up to date for key '$key' in $file"
        return 0
    fi
    
    sed -i "\|$key|d" "$file"
    printf '%s\n' "$text" >> "$file"
    
    log_info_scope "pkg" "Updated key '$key' in $file"
}
