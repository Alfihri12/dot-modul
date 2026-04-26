# Module Guide

This repo is built around modules.
If you understand how one module works, you basically understand the whole project.

## What counts as a module

A module is any direct child folder inside [`modules/`](../modules) that:

- does not start with `_`
- contains a `module.conf`

So these are valid modules right now:

- `core-apps`
- `hyprland`
- `waybar`

And this folder is intentionally ignored:

- `_template`

## Module lifecycle

When a module is selected by the installer, the flow is:

1. load `module.conf`
2. load `custom.sh` if present
3. run `module_before_run` if defined
4. install packages from `MODULE_PACKAGES`
5. install AUR packages from `MODULE_AUR_PACKAGES`
6. enable services from `MODULE_SYSTEM_SERVICES`
7. enable user services from `MODULE_USER_SERVICES`
8. symlink entries from `config/` into `~/.config`
9. run `module_after_run` if defined

This keeps the module behavior predictable and easy to extend.

When a module is disabled with `./module.sh disable <module>`, a separate cleanup flow is available:

1. mark the module as disabled
2. optionally unlink entries from `MODULE_CONFIG_DIR`
3. optionally disable services from `MODULE_SYSTEM_SERVICES`
4. optionally disable services from `MODULE_USER_SERVICES`
5. optionally remove packages from `MODULE_PACKAGES`
6. optionally remove AUR packages from `MODULE_AUR_PACKAGES`

The module directory itself is not deleted.

## Module status

Every module starts as enabled unless you disable it with:

```bash
./module.sh disable <module>
```

To enable it again:

```bash
./module.sh enable <module>
```

To check the current state:

```bash
./module.sh list
```

In an interactive shell, `./module.sh disable <module>` asks two follow-up questions:

1. do you want to unlink that module's config from `~/.config`
2. if yes, do you also want to uninstall its packages and disable its services

That gives you three useful modes:

- disable only
- disable and unlink
- disable, unlink, and uninstall

If the command runs without an interactive terminal, only the module state is updated.

Disabled modules are stored in:

```text
$XDG_STATE_HOME/dot-modul/disabled-modules
```

## Current module reference

### `core-apps`

This module covers baseline desktop services and apps.
Right now it includes things like:

- `networkmanager`
- Bluetooth packages
- PipeWire and audio stack packages
- related system and user services

Use this when you want the core desktop services to be ready first.

### `hyprland`

This is the main desktop environment module.
It contains:

- Hyprland packages
- launcher, clipboard, screenshot, and wallpaper tools
- Hyprland config files
- helper scripts stored inside the module config tree
- wallpaper rotation with optional pywal refresh
- a restart selector for panel scripts such as Waybar

Use this when you want the compositor and the main desktop setup.
For the script details and keybinds, check [Hyprland features](hyprland.md).

### `waybar`

This module contains the Waybar setup for the project.
It includes:

- the Waybar config directory
- styling files
- the package list currently used by the repo for this module

Use this when you want the bar configuration on top of the Hyprland setup.

## Anatomy of a module

The simplest shape looks like this:

```text
modules/my-module/
├── config/
├── custom.sh
└── module.conf
```

Only `module.conf` is required.
`custom.sh` and `config/` are optional.

## `module.conf`

The `module.conf` file is just a Bash file.
Usually it defines arrays like this:

```bash
#!/usr/bin/env bash

MODULE_CONFIG_DIR="${MODULE_DIR}/config"

MODULE_PACKAGES=()
MODULE_AUR_PACKAGES=()
MODULE_SYSTEM_SERVICES=()
MODULE_USER_SERVICES=()
```

What each variable means:

- `MODULE_CONFIG_DIR`: where config files should be linked from
- `MODULE_PACKAGES`: packages installed with `pacman`, and removed again if you choose uninstall
- `MODULE_AUR_PACKAGES`: packages installed from AUR, and removed again if you choose uninstall
- `MODULE_SYSTEM_SERVICES`: system services enabled with `systemctl`, and disabled again if you choose uninstall
- `MODULE_USER_SERVICES`: user services enabled with `systemctl --user`, and disabled again if you choose uninstall

## `custom.sh`

If a module needs custom logic, add a `custom.sh`.
You can define either or both of these hooks:

```bash
module_before_run() {
    :
}

module_after_run() {
    :
}
```

This is useful for small preparation or cleanup steps that do not fit into package/service/config declarations.

## Config linking behavior

Anything inside a module `config/` directory is linked into `~/.config`.

Example:

```text
modules/waybar/config/waybar
```

becomes:

```text
~/.config/waybar
```

If a destination already exists:

- existing symlinks are replaced
- regular files or directories are moved to a backup like `.bak.<timestamp>`

If you later choose unlink from `./module.sh disable <module>`:

- matching symlinks for that module are removed
- regular files are not deleted
- symlinks that point to another source are skipped

## Creating a new module

1. Create a new folder inside `modules/`
2. Add a `module.conf`
3. Optionally add `config/`
4. Optionally add `custom.sh`
5. Run `./module.sh list` to make sure it is detected
6. Run `./install.sh` and pick it from the list

If you want a quick starting point, copy [`modules/_template`](../modules/_template).

## Good to know

- Module order follows the sorted folder names inside `modules/`
- The installer only accepts enabled modules when you use `--modules`
- Pressing Enter in the interactive installer selects all enabled modules
- Names and numeric indexes both work in the installer prompt
