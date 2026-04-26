#!/bin/bash

set -euo pipefail

restart_dir="${HOME}/.config/hypr/scripts/restart"
self_path="$(readlink -f "$0")"

is_panel_active() {
    local panel="$1"
    pgrep -x "$panel" >/dev/null 2>&1
}

mapfile -t scripts < <(
    find "$restart_dir" -maxdepth 1 -type f -name "*.sh" \
    | while IFS= read -r script; do
        if [[ "$(readlink -f "$script")" != "$self_path" ]]; then
            basename "$script"
        fi
    done \
    | sort
)

if ((${#scripts[@]} == 0)); then
    notify-send "Hypr restart" "Tidak ada script .sh di $restart_dir"
    exit 1
fi

active_scripts=()
for script in "${scripts[@]}"; do
    panel_name="${script%.sh}"
    if is_panel_active "$panel_name"; then
        active_scripts+=("$script")
    fi
done

active_scripts_env=""
if ((${#active_scripts[@]} > 0)); then
    active_scripts_env="$(IFS=:; printf "%s" "${active_scripts[*]}")"
fi

if ((${#active_scripts[@]} == 1)); then
    bash "$restart_dir/${active_scripts[0]}"
    exit 0
fi

exec env HYPR_ACTIVE_SCRIPTS="$active_scripts_env" kitty --title "Hypr Restart" bash -lc '
restart_dir="$HOME/.config/hypr/scripts/restart"
scripts=("$@")
active_scripts=()

if [[ -n "${HYPR_ACTIVE_SCRIPTS:-}" ]]; then
    IFS=: read -r -a active_scripts <<< "$HYPR_ACTIVE_SCRIPTS"
fi

is_active_script() {
    local script="$1"
    local active
    for active in "${active_scripts[@]}"; do
        [[ "$active" == "$script" ]] && return 0
    done
    return 1
}

printf "Pilih script restart:\n\n"
for i in "${!scripts[@]}"; do
    label="${scripts[$i]}"
    if is_active_script "$label"; then
        label="$label [active]"
    fi
    printf "%d. %s\n" "$((i + 1))" "$label"
done

if ((${#active_scripts[@]} == 1)); then
    printf "\nTekan Enter untuk pakai panel aktif: %s\n" "${active_scripts[0]}"
elif ((${#active_scripts[@]} > 1)); then
    printf "\nPanel aktif terdeteksi: %s\n" "${active_scripts[*]}"
fi

printf "\nMasukkan nomor lalu Enter: "
read -r choice

if [[ -z "$choice" && ${#active_scripts[@]} -eq 1 ]]; then
    selected="${active_scripts[0]}"
elif [[ ! "$choice" =~ ^[0-9]+$ ]]; then
    printf "\nInput tidak valid.\n"
    sleep 1
    exit 1
else
    index=$((choice - 1))
    if ((index < 0 || index >= ${#scripts[@]})); then
        printf "\nPilihan di luar daftar.\n"
        sleep 1
        exit 1
    fi
    selected="${scripts[$index]}"
fi

printf "\nMenjalankan %s...\n" "$selected"
bash "$restart_dir/$selected"
sleep 1
' bash "${scripts[@]}"
