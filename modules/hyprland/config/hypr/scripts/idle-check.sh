#!/usr/bin/env bash

# Cek media atau proses penting
if playerctl -a status 2>/dev/null | grep -q "Playing"; then
    exit 0
fi

if pgrep -x "pacman" >/dev/null || pgrep -x "makepkg" >/dev/null || pgrep -x "ffmpeg" >/dev/null; then
    exit 0
fi

# Jalankan perintah sesuai yang diminta sama hypridle
# $1 itu argumen yang lu kirim dari config hypridle
$1




