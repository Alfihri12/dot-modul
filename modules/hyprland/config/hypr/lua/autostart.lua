-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")                                                                -- Execute waybar
    hl.exec_cmd("awww-daemon")                                                           -- Execute walpaper
    hl.exec_cmd("~/.config/hypr/scripts/wallpaper.py daemon --interval 3600 --with-wal") -- Execute hyprpaper
    hl.exec_cmd("mako")                                                                  -- Execute notification daemon
    hl.exec_cmd("hypridle")                                                              -- Execute idle daemon
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service")                        -- Start polkit agent
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")                     -- Start gnome keyring
    hl.exec_cmd("wl-paste --type text --watch cliphist store")                           -- Start clipboard manager for text
    hl.exec_cmd("wl-paste --type image --watch cliphist store")                          -- Start clipboard manager for images
    hl.exec_cmd("cliphist daemon")                                                       -- Start clipboard manager daemon
    -- hl.exec_cmd("kdeconnectd")                                                           -- Start KDE Connect daemon
end)
