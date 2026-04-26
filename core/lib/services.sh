#!/usr/bin/env bash

enable_service() {
    local service="$1"

    if systemctl is-enabled "$service" >/dev/null 2>&1; then
        log_idempotent "service" "system service already enabled: $service"
        return 0
    fi

    log_info_scope "service" "Enabling system service $service"
    sudo systemctl enable --now "$service"
}

enable_user_service() {
    local service="$1"

    if systemctl --user is-enabled "$service" >/dev/null 2>&1; then
        log_idempotent "service" "user service already enabled: $service"
        return 0
    fi

    log_info_scope "service" "Enabling user service $service"
    systemctl --user enable --now "$service"
}

enable_services() {
    local service

    for service in "$@"; do
        enable_service "$service"
    done
}

enable_user_services() {
    local service

    for service in "$@"; do
        enable_user_service "$service"
    done
}

disable_service() {
    local service="$1"

    if ! systemctl is-enabled "$service" >/dev/null 2>&1; then
        log_idempotent "service" "system service already disabled: $service"
        return 0
    fi

    log_info_scope "service" "Disabling system service $service"
    sudo systemctl disable --now "$service"
}

disable_user_service() {
    local service="$1"

    if ! systemctl --user is-enabled "$service" >/dev/null 2>&1; then
        log_idempotent "service" "user service already disabled: $service"
        return 0
    fi

    log_info_scope "service" "Disabling user service $service"
    systemctl --user disable --now "$service"
}

disable_services() {
    local service

    for service in "$@"; do
        disable_service "$service"
    done
}

disable_user_services() {
    local service

    for service in "$@"; do
        disable_user_service "$service"
    done
}
