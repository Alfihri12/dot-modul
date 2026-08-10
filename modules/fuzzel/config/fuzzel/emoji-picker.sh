#!/bin/bash

FUZZEL_DIR="$HOME/.config/fuzzel"
EMOJI_FILE="$FUZZEL_DIR/emojis.txt"
RECENT_FILE="$FUZZEL_DIR/recent.txt"

touch "$RECENT_FILE"

selected=$(
    {
        cat "$RECENT_FILE"
        grep -Fvxf "$RECENT_FILE" "$EMOJI_FILE"
    } |
    fuzzel \
        --dmenu \
        --prompt="Emoji > "
)

[ -z "$selected" ] && exit 0

emoji=$(printf '%s' "$selected" | cut -d' ' -f1)

wtype "$emoji"

grep -Fvxf <(printf '%s\n' "$selected") "$RECENT_FILE" > "$RECENT_FILE.tmp"
printf '%s\n' "$selected" > "$RECENT_FILE.new"
cat "$RECENT_FILE.tmp" >> "$RECENT_FILE.new"
mv "$RECENT_FILE.new" "$RECENT_FILE"
rm "$RECENT_FILE.tmp"