# Hyprland Features

The Hyprland module now ships with a couple of extra helpers beyond the base compositor config:

- a wallpaper manager written in Python
- optional pywal color regeneration
- a restart selector for panel scripts

This page covers how those pieces work together.

## Wallpaper manager

Wallpaper changes are handled by:

```text
~/.config/hypr/scripts/wallpaper.py
```

What it does:

- reads images from `~/Pictures/Wallpapers`
- supports `.jpg`, `.jpeg`, `.png`, and `.webp`
- avoids repeating the last wallpaper when possible
- stores the last selected image in:

```text
$XDG_CACHE_HOME/hyprland-wallpaper/last_wallpaper
```

If `XDG_CACHE_HOME` is not set, that usually becomes:

```text
~/.cache/hyprland-wallpaper/last_wallpaper
```

## Commands

Change wallpaper once:

```bash
~/.config/hypr/scripts/wallpaper.py once
```

Change wallpaper once and regenerate pywal colors:

```bash
~/.config/hypr/scripts/wallpaper.py once --with-wal
```

Run it as a daemon with a custom interval:

```bash
~/.config/hypr/scripts/wallpaper.py daemon --interval 1800 --with-wal
```

The default interval defined in the script is `3600` seconds.

## Current Hyprland autostart behavior

The current Hyprland config starts the wallpaper flow automatically on login:

- `awww-daemon`
- `~/.config/hypr/scripts/wallpaper.py daemon --interval 3600 --with-wal`

That means wallpaper rotation is already enabled by default when the Hyprland module is active.

## Pywal refresh flow

When you use `--with-wal`, the wallpaper script will:

1. apply the new wallpaper
2. run `wal -i <image>`
3. detect active restart scripts
4. run those restart scripts so pywal-aware apps can refresh

This makes wallpaper changes feel more complete because the color theme and active panel can update together.

## Restart selector

The restart selector lives here:

```text
~/.config/hypr/scripts/restart/selector.sh
```

It scans this directory:

```text
~/.config/hypr/scripts/restart/
```

Rules:

- the selector menu reads `.sh` files from that directory
- `selector.sh` itself is ignored
- the process name is matched against the script filename without `.sh`

For automatic pywal refresh, the wallpaper script only uses executable `.sh` files from the same folder.

Example:

- `waybar.sh` is considered active when a `waybar` process is running

## Selector behavior

The selector tries to be convenient:

- if exactly one panel script is active, it runs that script immediately
- if more than one active panel is detected, it opens a small picker in `kitty`
- if no active panel is detected, it still opens the picker so you can choose manually

The active script list is also reused by the wallpaper script when it needs to refresh pywal-dependent panels.

## Current restart scripts

Right now the repo ships with:

- `waybar.sh`

That script:

- stops Waybar
- starts Waybar again in the background
- reloads Hyprland

## Default keybinds

These shortcuts are currently defined in the Hyprland config:

- `SUPER_SHIFT + M`: run `~/.config/hypr/scripts/restart/selector.sh`
- `SUPER_SHIFT + N`: run `~/.config/hypr/scripts/wallpaper.py once --with-wal`

## Keybind cheat sheet

`SUPER` is the main modifier in this setup.
On most keyboards, that means the Windows key.

### Apps and launcher

| Keybind | Action |
| --- | --- |
| `SUPER + R` | Open `hyprlauncher` |
| `SUPER + Return` | Open terminal (`kitty`) |
| `SUPER + E` | Open file manager (`kitty nnn`) |
| `SUPER + W` | Open browser (`google-chrome-stable`) |
| `SUPER + C` | Open editor (`code`) |
| `SUPER + V` | Open clipboard history (`kitty cliphist list`) |
| `Print` | Take a selected-area screenshot with `grim` + `slurp` |
| `SUPER_SHIFT + N` | Change wallpaper once and refresh pywal-aware apps |
| `SUPER_SHIFT + M` | Open the panel restart selector |

The screenshot bind saves files into:

```text
~/Pictures/screenshot/<timestamp>.png
```

### Window controls

| Keybind | Action |
| --- | --- |
| `SUPER + Q` | Close the active window |
| `SUPER + I` | Toggle floating for the active window |
| `SUPER + P` | Toggle `pseudo` in dwindle layout |
| `SUPER + O` | Toggle split in dwindle layout |

### Focus movement

| Keybind | Action |
| --- | --- |
| `SUPER + H` | Focus left |
| `SUPER + J` | Focus up |
| `SUPER + K` | Focus down |
| `SUPER + L` | Focus right |

### Workspace controls

| Keybind | Action |
| --- | --- |
| `SUPER + 1..9` | Switch to workspace `1..9` |
| `SUPER + 0` | Switch to workspace `10` |
| `SUPER + ALT + 1..9` | Move active window to workspace `1..9` |
| `SUPER + ALT + 0` | Move active window to workspace `10` |
| `SUPER + mouse wheel down` | Go to next workspace |
| `SUPER + mouse wheel up` | Go to previous workspace |
| `SUPER + ALT + mouse wheel down` | Move active window to next workspace |
| `SUPER + ALT + mouse wheel up` | Move active window to previous workspace |

### Special workspace

| Keybind | Action |
| --- | --- |
| `SUPER + S` | Toggle the special workspace `magic` |
| `SUPER_SHIFT + S` | Move active window to special workspace `magic` |
| `SUPER_SHIFT + D` | Move active window to the next workspace |

### Mouse actions

| Keybind | Action |
| --- | --- |
| `SUPER + Left mouse drag` | Move window |
| `SUPER + Right mouse drag` | Resize window |

### Resize mode

To enter resize mode:

| Keybind | Action |
| --- | --- |
| `ALT + R` | Enter resize submap |

While resize mode is active:

| Keybind | Action |
| --- | --- |
| `Left` | Shrink width |
| `Right` | Grow width |
| `Up` | Shrink height |
| `Down` | Grow height |
| `Escape` | Exit resize mode |

### Media and brightness keys

| Keybind | Action |
| --- | --- |
| `XF86AudioRaiseVolume` | Increase output volume by `5%` |
| `XF86AudioLowerVolume` | Decrease output volume by `5%` |
| `XF86AudioMute` | Toggle output mute |
| `XF86AudioMicMute` | Toggle mic mute |
| `XF86MonBrightnessUp` | Increase brightness |
| `XF86MonBrightnessDown` | Decrease brightness |
| `XF86AudioNext` | Next track |
| `XF86AudioPause` | Play or pause |
| `XF86AudioPlay` | Play or pause |
| `XF86AudioPrev` | Previous track |

## Good to know

- The installer already seeds `~/Pictures/Wallpapers` from the repo wallpaper assets if the folder is empty.
- The Hyprland module already includes `python-pywal16` in its package list, so the pywal part is expected by this setup.
- If you want extra restart targets later, drop new `.sh` files into `~/.config/hypr/scripts/restart/`.
- Make those scripts executable if you want the wallpaper script to restart them automatically after a `--with-wal` refresh.
- Playback media keys use `playerctl`, so make sure it is installed if you want those controls to work.
