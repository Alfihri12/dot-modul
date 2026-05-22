-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@165",
    position = "0x0",
    scale    = "1",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use


-------------------
---- AUTOSTART ----
-------------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")                                                                -- Execute waybar
    hl.exec_cmd("awww-daemon")                                                           -- Execute walpaper
    hl.exec_cmd("~/.config/hypr/scripts/wallpaper.py daemon --interval 3600 --with-wal") -- Execute hyprpaper
    hl.exec_cmd("mako")                                                                  -- Execute notification daemon
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service")                        -- Start polkit agent
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")                     -- Start gnome keyring
    hl.exec_cmd("wl-paste --type text --watch cliphist store")                           -- Start clipboard manager for text
    hl.exec_cmd("wl-paste --type image --watch cliphist store")                          -- Start clipboard manager for images
end)



-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- cursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- nvidia
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("GBM_BACKEND", "nvidia-drm")

-- disable hardware cursor (uncomment if you have cursor issues, e.g. black squares instead of a cursor)
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- performance
hl.env("__GL_GSYNC_ALLOWED", "0")
hl.env("__GL_VRR_ALLOWED", "0")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in          = 2,
        gaps_out         = 4,

        border_size      = 2,

        col              = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing    = true,

        layout           = "dwindle",
    },

    decoration = {
        rounding         = 4,
        rounding_power   = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        dim_inactive     = true,
        dim_strength     = 0.2,

        shadow           = {
            enabled      = true,
            range        = 6,
            offset       = { x = 0, y = 4 },
            render_power = 10,
            color        = 0xee1a1a1a,
        },

        blur             = {
            enabled                   = true,
            xray                      = true,
            special_                  = false, -- If true, only blur windows with blur special set to true. Otherwise, blur all windows.
            new_optimization          = true,  -- If true, uses a new blur optimization that can be faster on some systems. May cause issues on some drivers. Use the old optimization if you experience issues.
            size                      = 8,
            passes                    = 3,
            brightness                = 1,
            noise                     = 0.05,
            contrast                  = 0.89,
            vibrancy                  = 0.5,
            vibrancy_darkness         = 0.5,
            popups                    = false, -- If true, also blur popups (menus, tooltips, etc). May cause performance issues on some systems.
            popups_ignorealpha        = 0.6,   -- If true, ignores alpha value of popups when deciding whether to blur them. This can be useful if you have transparent popups that you still want to be blurred, but may cause performance issues on some systems.
            input_methods             = true,  -- If true, also blur input methods (on-screen keyboards, etc). May cause performance issues on some systems.
            input_methods_ignorealpha = 0.8
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper      = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        background_color             = rgba(D1011FF),
        disable_hyprland_logo        = false, -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering     = true,
        vrr                          = 0,
        mouse_move_enables_dpms      = true,
        key_press_enables_dpms       = true,
        animate_manual_resizes       = false,
        animate_mouse_windowdragging = false,
        enable_swallow               = false,
        on_focus_under_fullscreen    = 2,
        allow_session_lock_restore   = true,
        session_lock_xray            = true,
        initial_workspace_tracking   = false,
        focus_on_activate            = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout              = "us",
        numlock_by_default     = true,
        repeat_delay           = 250,
        repeat_rate            = 35,

        follow_mouse           = 1,
        off_window_axis_events = 2,
        sensitivity            = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad               = {
            natural_scroll = true,
            disable_while_typing = true,
            clicfinger_behavior = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

-- ############ VARIABLES #############
local mainMod     = "SUPER"
local shiftMod    = "SUPER + SHIFT"
local altMod      = "SUPER + ALT"

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "pkill fuzzel || fuzzel"
local browser     = "google-chrome-stable"
local editor      = "code"
local notes       = "obsidian"
local clipboard   = "kitty cliphist list"
local screenshot  = [[grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%s).png]]

-- ############ APPS #############
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(notes))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd(screenshot))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipboard))

-- ############ WINDOW CONTROL #############
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- fullscreen, 1 = maximized
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- fullscreen, 0 biasanya fullscreen biasa/toggle
hl.bind(shiftMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(shiftMod .. " + SPACE", hl.dsp.window.center())

hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "d" }))

-- move window
hl.bind(shiftMod .. " + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(shiftMod .. " + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(shiftMod .. " + J", hl.dsp.window.move({ direction = "u" }))
hl.bind(shiftMod .. " + K", hl.dsp.window.move({ direction = "d" }))

-- layout
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + O", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + I", hl.dsp.window.float({ action = "toggle" }))

-- special workspace
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(shiftMod .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- ############ WORKSPACES #############

-- switch workspace: SUPER + 1..0
for i = 1, 10 do
    local key = i % 10 -- 10 jadi tombol 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
end

-- move window to workspace: SUPER + ALT + 1..0
for i = 1, 10 do
    local key = i % 10 -- 10 jadi tombol 0
    hl.bind(altMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- scroll workspace
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "r-1" }))

-- scroll move window
hl.bind(altMod .. " + mouse_down", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(altMod .. " + mouse_up", hl.dsp.window.move({ workspace = "r-1" }))

-- arrow workspace
hl.bind(mainMod .. " + right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + left", hl.dsp.focus({ workspace = "r-1" }))

-- arrow move window
hl.bind(altMod .. " + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(altMod .. " + left", hl.dsp.window.move({ workspace = "r-1" }))

-- ############ MOUSE #############
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ############ RESIZE MODE #############
hl.bind(mainMod .. " + RCTRL", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ############ SYSTEM / SCRIPTS #############
hl.bind(shiftMod .. " + M", hl.dsp.exec_cmd("~/.config/hypr/scripts/restart/selector.sh"))
hl.bind(shiftMod .. " + N", hl.dsp.exec_cmd("~/.config/hypr/scripts/wal-all.sh"))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("hyprlock"))

-- ############ MEDIA KEYS #############
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
    { locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    { locked = true }
)

hl.bind("XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind("XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind("XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    { locked = true }
)


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})
