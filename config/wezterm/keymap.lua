local wezterm = require("wezterm")
local act = wezterm.action

return function(config)
    config.keys = {
        {
            key = "a",
            mods = "CTRL",
            action = act.ActivateKeyTable({ name = "tmux_keys", one_shot = true }),
        },
    }

    config.key_tables = {
        tmux_keys = {
            -- pane
            {
                key = "v",
                action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
            },
            {
                key = "s",
                action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
            },
            {
                key = "h",
                action = act.ActivatePaneDirection("Left"),
            },
            {
                key = "j",
                action = act.ActivatePaneDirection("Down"),
            },
            {
                key = "k",
                action = act.ActivatePaneDirection("Up"),
            },
            {
                key = "l",
                action = act.ActivatePaneDirection("Right"),
            },

            {
                key = "H",
                action = act.Multiple({
                    act.AdjustPaneSize({ "Left", 2 }),
                    act.ActivateKeyTable({ name = "resize_pane", timeout_milliseconds = 600, one_shot = false, until_unknow = true }),
                }),
            },
            {
                key = "J",
                action = act.Multiple({
                    act.AdjustPaneSize({ "Down", 2 }),
                    act.ActivateKeyTable({ name = "resize_pane", timeout_milliseconds = 600, one_shot = false, until_unknow = true }),
                }),
            },
            {
                key = "K",
                action = act.Multiple({
                    act.AdjustPaneSize({ "Up", 2 }),
                    act.ActivateKeyTable({ name = "resize_pane", timeout_milliseconds = 600, one_shot = false, until_unknow = true }),
                }),
            },
            {
                key = "L",
                action = act.Multiple({
                    act.AdjustPaneSize({ "Right", 2 }),
                    act.ActivateKeyTable({ name = "resize_pane", timeout_milliseconds = 600, one_shot = false, until_unknow = true }),
                }),
            },

            -- tab
            {
                key = "c",
                action = act.SpawnTab("CurrentPaneDomain"),
            },
            {
                key = "1",
                action = act.ActivateTab(0),
            },
            {
                key = "2",
                action = act.ActivateTab(1),
            },
            {
                key = "3",
                action = act.ActivateTab(2),
            },
            {
                key = "4",
                action = act.ActivateTab(3),
            },
            {
                key = "5",
                action = act.ActivateTab(4),
            },
            {
                key = "6",
                action = act.ActivateTab(5),
            },
            {
                key = "7",
                action = act.ActivateTab(6),
            },
        },

        resize_pane = {
            {
                key = "H",
                action = act.AdjustPaneSize({ "Left", 2 }),
            },
            {
                key = "J",
                action = act.AdjustPaneSize({ "Down", 2 }),
            },
            {
                key = "K",
                action = act.AdjustPaneSize({ "Up", 2 }),
            },
            {
                key = "L",
                action = act.AdjustPaneSize({ "Right", 2 }),
            },
        },
    }
end
