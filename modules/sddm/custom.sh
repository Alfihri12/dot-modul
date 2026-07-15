#!/usr/bin/env bash

module_before_run() {
    : # SEBELUM RUN
}

module_after_run() {
    # masukin sddm.conf ke /etc/sddm.conf
    local SDDM_SYSTEM_CONF="/etc/sddm.conf"
    local SDDM_MODULE_CONF="${MODULES_DIR}/sddm/sddm.conf"

    log_info "Installing SDDM configuration..."

    sudo install -Dm644 "$SDDM_MODULE_CONF" "$SDDM_SYSTEM_CONF"
    # set silent theme `metadata.desktop` di /usr/share/sddm/themes/silent/
}
