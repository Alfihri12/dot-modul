#!/usr/bin/env bash

source ~/.config/waybar/scripts/impor.sh
pkill -x waybar >/dev/null 2>&1 || true
nohup waybar >/dev/null 2>&1 &
hyprctl reload
