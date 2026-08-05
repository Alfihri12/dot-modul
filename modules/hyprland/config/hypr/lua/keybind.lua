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
local browser     = "brave"
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
hl.bind(shiftMod .. " + S", hl.dsp.exec_cmd(screenshot))
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
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind(shiftMod .. " + M", hl.dsp.window.move({ workspace = "special:magic" }))

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
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ############ SYSTEM / SCRIPTS #############
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/.config/hypr/scripts/restart/selector.sh"))
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