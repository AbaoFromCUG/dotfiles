return function()
    local code_navigation = require("nvim-navic")
    require("lualine").setup({
        options = {
            icons_enabled = true,
            icon_only = true,
            theme = "gruvbox",
            component_separators = { "", "" },
            section_separators = { "", "" },
            disabled_filetypes = {},
        },
        sections = {
            lualine_a = {
                "mode",
                {
                    require("noice").api.statusline.mode.get,
                    cond = require("noice").api.statusline.mode.has,
                    color = { fg = "#ff9e64" },
                },
            },
            lualine_b = {
                "filename",
                "diff",
                {
                    function()
                        return code_navigation.get_location()
                    end,
                    cond = code_navigation.is_available,
                },
            },
            lualine_c = {
                "launcher",
                "overseer",
            },
            lualine_x = { "diagnostics" },
            lualine_y = { "encoding", "fileformat", "filetype" },
            lualine_z = { "progress", "location" },
        },
        extensions = {},
    })
end
