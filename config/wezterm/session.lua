local wezterm = require("wezterm")
local mux = wezterm.mux

return function(config)
    wezterm.on("gui-startup", function()
        local tab, _, window = mux.spawn_window({ cwd = "/home/abao/.dotfiles" })
        tab:set_title("dotfiles")
        tab, _, window = window:spawn_tab({ cwd = "/home/abao/Documents" })
        tab:set_title("work")
    end)
end
