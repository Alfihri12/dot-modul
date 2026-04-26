#!/bin/bash

. "${HOME}/.cache/wal/colors.sh"

conffile="${HOME}/.config/mako/config"

set_color() {
    key=$1
    value=$2

    if grep -q "^$key=" "$conffile"; then
        sed -i "s/^$key=.*/$key=$value/" "$conffile"
    else
        echo "$key=$value" >> "$conffile"
    fi
}

set_color "background-color" "$background"
set_color "text-color" "$foreground"
set_color "border-color" "$color13"

makoctl reload
