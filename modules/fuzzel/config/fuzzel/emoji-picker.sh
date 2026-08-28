#!/bin/bash

FUZZEL_DIR="$HOME/.config/fuzzel"
EMOJI_FILE="$FUZZEL_DIR/emojis.txt"
RECENT_FILE="$FUZZEL_DIR/recent.txt"
MAX_RECENT=20

touch "$RECENT_FILE"

selected=$(
    {
        cat "$RECENT_FILE"
        grep -Fvxf "$RECENT_FILE" "$EMOJI_FILE"
    } | fuzzel --dmenu --prompt="Emoji > "
)

[ -z "$selected" ] && exit 0

emoji=$(printf '%s' "$selected" | cut -d' ' -f1)

# Simpan emoji ke clipboard tanpa karakter newline ekstra
# printf '%s' "$emoji" | wl-copy

# (Opsional) Jika kamu ingin emojinya langsung diketik otomatis SEKALIGUS masuk clipboard,
wtype "$emoji"

# Update recent: simpan yang baru di atas, buang duplikat, batasi maksimal 20 item
{
    printf '%s\n' "$selected"
    grep -Fvx "$selected" "$RECENT_FILE"
} | head -n "$MAX_RECENT" > "$RECENT_FILE.tmp" && mv "$RECENT_FILE.tmp" "$RECENT_FILE"
