#!/bin/bash

. "${HOME}/.cache/wal/colors.sh"

cat > "${HOME}/.config/fuzzel/fuzzel.ini" <<EOF
[main]
font=JetBrainsMono Nerd Font:size=12
width=30
border-width=2
border-radius=10

[colors]
background=${background}ee
text=${foreground}ff
selection=${color8}ff
selection-text=${foreground}ff
border=${color4}ff
EOF
