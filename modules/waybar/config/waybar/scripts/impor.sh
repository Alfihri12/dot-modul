#!/usr/bin/env bash
set -euo pipefail

selected_user="${1:-${WAYBAR_WAL_USER:-${USER:-$(id -un)}}}"
style_css="${WAYBAR_STYLE_CSS:-$HOME/.config/waybar/style.css}"
wal_css="/home/${selected_user}/.cache/wal/colors-waybar.css"
import_line="@import \"${wal_css}\";"

if [[ ! "$selected_user" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    printf 'Username tidak valid: %s\n' "$selected_user" >&2
    exit 1
fi

if [[ ! -f "$style_css" ]]; then
    printf 'File style.css tidak ditemukan: %s\n' "$style_css" >&2
    exit 1
fi

if [[ ! -f "$wal_css" ]]; then
    printf 'File wal tidak ditemukan untuk user %s: %s\n' "$selected_user" "$wal_css" >&2
    exit 1
fi

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

awk -v import_line="$import_line" '
BEGIN {
    replaced = 0
}
/^@import ".*\/\.cache\/wal\/colors-waybar\.css";$/ {
    if (!replaced) {
        print import_line
        replaced = 1
    }
    next
}
{
    print
}
END {
    # kalau belum ada import, nanti ditambah di luar awk
}
' "$style_css" > "$tmp_file"

if ! grep -Fqx "$import_line" "$tmp_file"; then
    {
        printf '%s\n' "$import_line"
        cat "$tmp_file"
    } > "${tmp_file}.new"
    mv "${tmp_file}.new" "$tmp_file"
fi

mv "$tmp_file" "$style_css"