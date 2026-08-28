-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in          = 2,
        gaps_out         = 4,
        border_size      = 2,
        col              = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = true,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 4,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        dim_inactive     = true,
        dim_strength     = 0,
        shadow           = {
            enabled      = true,
            range        = 6,
            offset       = { 0, 4 },
            render_power = 10,
            color        = 0xee1a1a1a,
        },
        blur             = {
            enabled                   = true,
            xray                      = true,
            size                      = 8,
            passes                    = 3,
            brightness                = 1,
            noise                     = 0.05,
            contrast                  = 0.89,
            vibrancy                  = 0.5,
            vibrancy_darkness         = 0.5,
            popups                    = false, 
            popups_ignorealpha        = 0.6,  
            input_methods             = true, 
            input_methods_ignorealpha = 0.8
        },
    },
    animations = {
        enabled = true,
    },
})

-- ############ ANIMATION CURVES #############

hl.curve("expressiveFastSpatial", {
    type = "bezier",
    points = { { 0.42, 1.67 }, { 0.21, 0.90 } },
})

hl.curve("expressiveSlowSpatial", {
    type = "bezier",
    points = { { 0.39, 1.29 }, { 0.35, 0.98 } },
})

hl.curve("expressiveDefaultSpatial", {
    type = "bezier",
    points = { { 0.38, 1.21 }, { 0.22, 1.00 } },
})

hl.curve("emphasizedDecel", {
    type = "bezier",
    points = { { 0.05, 0.7 }, { 0.1, 1 } },
})

hl.curve("emphasizedAccel", {
    type = "bezier",
    points = { { 0.3, 0 }, { 0.8, 0.15 } },
})

hl.curve("standardDecel", {
    type = "bezier",
    points = { { 0, 0 }, { 0, 1 } },
})

hl.curve("menu_decel", {
    type = "bezier",
    points = { { 0.1, 1 }, { 0, 1 } },
})

hl.curve("menu_accel", {
    type = "bezier",
    points = { { 0.52, 0.03 }, { 0.72, 0.08 } },
})

hl.curve("stall", {
    type = "bezier",
    points = { { 1, -0.1 }, { 0.7, 0.85 } },
})

-- ############ ANIMATIONS #############

-- windows
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel",
    style = "popin 80%",
})

hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 2,
    bezier = "emphasizedDecel",
    style = "popin 90%",
})

hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 2,
    bezier = "emphasizedDecel",
})

hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel",
    style = "slide",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = 10,
    bezier = "emphasizedDecel",
})

-- layers
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 2.7,
    bezier = "emphasizedDecel",
    style = "popin 93%",
})

hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 2.4,
    bezier = "menu_accel",
    style = "popin 94%",
})

-- fade
hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 0.5,
    bezier = "menu_decel",
})

hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 2.7,
    bezier = "stall",
})

-- workspaces
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 7,
    bezier = "menu_decel",
    style = "slide",
})

-- special workspace
hl.animation({
    leaf = "specialWorkspaceIn",
    enabled = true,
    speed = 2.8,
    bezier = "emphasizedDecel",
    style = "slidevert",
})

hl.animation({
    leaf = "specialWorkspaceOut",
    enabled = true,
    speed = 1.2,
    bezier = "emphasizedAccel",
    style = "slidevert",
})

-- zoom
hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 3,
    bezier = "standardDecel",
})

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})