local wezterm = require("wezterm")

local config = {
    enable_wayland = true,
    window_decorations = "RESIZE",
    front_end = "WebGpu",
    font_size = 14,
    -- => == !=  😀
    font = wezterm.font_with_fallback({
        "FiraCode Nerd Font",
    }),
    window_background_opacity = 0.8,
}

-- config.color_scheme = "Tomorrow Night"
config.color_scheme = "Snazzy"
config.status_update_interval = 500

require("keymap")(config)
require("components")(config)
require("session")(config)

return config
