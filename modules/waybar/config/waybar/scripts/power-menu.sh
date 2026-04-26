#!/bin/bash

chosen=$(printf "Shutdown\nReboot\nLogout\nLock" | fuzzel --dmenu --prompt "Power")

case "$chosen" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Logout) hyprctl dispatch exit ;;
    Lock) hyprlock ;;
esac
