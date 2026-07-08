-- -- Bootstrap hipe plugin manager
-- do
--     local home = os.getenv("HOME")
--     local lua_dir = home .. "/Documents/hypr-plugins/hipe.hypr/lua"
--     package.path = lua_dir .. "/?.lua;" .. lua_dir .. "/?/init.lua;" .. package.path
-- end


do
    local data_dir = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
    local hipe_dir = data_dir .. "/hyprland/hipe/hipe.hypr"
    local lua_path = hipe_dir .. "/lua/?.lua;" .. hipe_dir .. "/lua/?/init.lua"

    package.path = lua_path .. ";" .. package.path

    local ok, err = pcall(require, "hipe")
    if not ok then
        os.execute("GIT_TERMINAL_PROMPT=0 git clone git@github.com:AbaoFromCUG/hipe.hypr " .. hipe_dir)
        ok, err = pcall(require, "hipe")
        if not ok then
            error("failed to load hipe: " .. tostring(err))
        end
    end
end

require("hipe").setup({
    spec = {
        {
            "AbaoFromCUG/dynamic-monitors.hypr",
            ---@type dynamic_monitors.Config
            opts = {
                profiles = {
                    {
                        name = "dva lab",
                        monitors = {
                            {
                                selector  = "desc:Dell Inc. DELL S2721DS 5GWMQ43",
                                mode      = "2560x1440@59.95",
                                position  = "0x0",
                                scale     = 1,
                                transform = 1,
                            },
                            {
                                selector = "desc:Apple Computer Inc StudioDisplay 0xB46EA92B",
                                mode     = "5120x2880@60",
                                position = "1440x560",
                                scale    = 2,
                            },
                            {
                                selector = "desc:Lenovo Group Limited 0x8AAF",
                                mode     = "3072x1920@60",
                                position = "4000x800",
                                scale    = "auto",
                                optional = false,
                                switches = { "Lid Switch" },
                                devices  = {
                                    "gxtp7936:00-27c6:012",
                                    "gxtp7936:00-27c6:012",
                                    "synacf00:00-06cb:cf00-touchpad",
                                    "synacf00:00-06cb:cf00-mouse"
                                }
                            },
                        }
                    },
                    {
                        name = "fallback",
                        monitors = {
                            {
                                selector = "",
                                mode = "preferred",
                                position = "auto",
                                scale = "auto",
                            },
                        }
                    },
                },
                notifications = true

            },
            dev = true,
        },
        {
            "AbaoFromCUG/virtual-desktops.hypr",
            opts = {
                enable_wrapping = true,
                name_maps = {
                    [1] = "dotfiles",
                    [2] = "work",
                    [3] = "browser",
                    [4] = "development",
                    [5] = "games",
                    [6] = "media",
                    [7] = "email",
                    [8] = "notes",
                    [9] = "social",
                    [10] = "chat",
                },
            },
            keys = {
                -- SUPER + 数字：切换虚拟桌面
                { "SUPER + 1",         function() require("virtual-desktops").vdesktop(1) end },
                { "SUPER + 2",         function() require("virtual-desktops").vdesktop(2) end },
                { "SUPER + 3",         function() require("virtual-desktops").vdesktop(3) end },
                { "SUPER + 4",         function() require("virtual-desktops").vdesktop(4) end },
                { "SUPER + 5",         function() require("virtual-desktops").vdesktop(5) end },
                { "SUPER + 6",         function() require("virtual-desktops").vdesktop(6) end },
                { "SUPER + 7",         function() require("virtual-desktops").vdesktop(7) end },
                { "SUPER + 8",         function() require("virtual-desktops").vdesktop(8) end },
                { "SUPER + 9",         function() require("virtual-desktops").vdesktop(9) end },
                { "SUPER + 0",         function() require("virtual-desktops").vdesktop(10) end },

                -- SUPER + 逗号/句号：切换上一个/下一个桌面
                { "SUPER + COMMA",     function() require("virtual-desktops").prev_vdesktop() end },
                { "SUPER + PERIOD",    function() require("virtual-desktops").next_vdesktop() end },

                -- SUPER + SHIFT + 数字：移动窗口并跟随
                { "SUPER + SHIFT + 1", function() require("virtual-desktops").move_to_vdesktop(1) end },
                { "SUPER + SHIFT + 2", function() require("virtual-desktops").move_to_vdesktop(2) end },
                { "SUPER + SHIFT + 3", function() require("virtual-desktops").move_to_vdesktop(3) end },
                { "SUPER + SHIFT + 4", function() require("virtual-desktops").move_to_vdesktop(4) end },
                { "SUPER + SHIFT + 5", function() require("virtual-desktops").move_to_vdesktop(5) end },
                { "SUPER + SHIFT + 6", function() require("virtual-desktops").move_to_vdesktop(6) end },
                { "SUPER + SHIFT + 7", function() require("virtual-desktops").move_to_vdesktop(7) end },
                { "SUPER + SHIFT + 8", function() require("virtual-desktops").move_to_vdesktop(8) end },
                { "SUPER + SHIFT + 9", function() require("virtual-desktops").move_to_vdesktop(9) end },
                { "SUPER + SHIFT + 0", function() require("virtual-desktops").move_to_vdesktop(10) end },

                -- SUPER + CTRL + 数字：静默移动窗口，不切换桌面
                { "SUPER + CTRL + 1",  function() require("virtual-desktops").move_to_vdesktop_silent(1) end },
                { "SUPER + CTRL + 2",  function() require("virtual-desktops").move_to_vdesktop_silent(2) end },
                { "SUPER + CTRL + 3",  function() require("virtual-desktops").move_to_vdesktop_silent(3) end },
                { "SUPER + CTRL + 4",  function() require("virtual-desktops").move_to_vdesktop_silent(4) end },
                { "SUPER + CTRL + 5",  function() require("virtual-desktops").move_to_vdesktop_silent(5) end },
                { "SUPER + CTRL + 6",  function() require("virtual-desktops").move_to_vdesktop_silent(6) end },
                { "SUPER + CTRL + 7",  function() require("virtual-desktops").move_to_vdesktop_silent(7) end },
                { "SUPER + CTRL + 8",  function() require("virtual-desktops").move_to_vdesktop_silent(8) end },
                { "SUPER + CTRL + 9",  function() require("virtual-desktops").move_to_vdesktop_silent(9) end },
                { "SUPER + CTRL + 0",  function() require("virtual-desktops").move_to_vdesktop_silent(10) end },
            },
            dev = true,
        },
        {
            "git@github.com:AbaoFromCUG/lua-plugin-template.hypr",
            opts = { option4 = "configured from plugins.lua" },
            keys = {
                { "SUPER + SHIFT + T", function()
                    require("plugin_name").do_something()
                end
                },
            },
        },
    },
    dev = {
        path = "~/Documents/hypr-plugins",
        fallback = true
    }
})
