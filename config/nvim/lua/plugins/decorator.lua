return {

    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",

        keys = {
            { "<S-l>", "<cmd>bnext<cr>",     desc = "focus right tab" },
            { "<S-h>", "<cmd>bprevious<cr>", desc = "focus left tab" },
        },
        opts = function()
            local activated_bg = "#323232"
            local inactivated_bg = "#1e1e1e"
            local bg = "#010101"
            return {
                options = {
                    separator_style = "slant",
                    custom_filter = function(buf_number)
                        if vim.iter({ "nofile", "prompt", "help", "quickfix" }):any(function(bt) return vim.bo[buf_number].buftype == bt end) then
                            return false
                        end
                        -- if vim.iter({ "^git.*", "fugitive", "Trouble", "dashboard" }):any(function(bt) return bt:match(vim.bo[buf_number].filetype) end) then
                        --     return false
                        -- end
                        return true
                    end,
                },
                highlights = {
                    background = { bg = inactivated_bg },
                    close_button = { bg = inactivated_bg },
                    separator = { fg = bg, bg = inactivated_bg },
                    separator_visible = { fg = bg, bg = inactivated_bg },
                    close_button_visible = { bg = inactivated_bg },
                    buffer_visible = { bg = inactivated_bg },

                    buffer_selected = { bold = true, italic = true, bg = activated_bg, fg = "#f0f0f0" },
                    close_button_selected = { bg = activated_bg, fg = "#f0f0f0" },
                    separator_selected = { fg = bg, bg = activated_bg },

                    fill = { bg = bg },
                },
            }
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",

        opts_extend = {
            "sections.lualine_a",
            "sections.lualine_b",
            "sections.lualine_c",
            "sections.lualine_d",
            "sections.lualine_x",
            "sections.lualine_y",
            "sections.lualine_z",
        },
        opts = {
            options = {
                icons_enabled = true,
                -- icon_only = true,
                -- section_separators = "",
                -- component_separators = "",
                theme = "tokyonight",
            },
            sections = {
                lualine_a = {
                    "mode",
                },
                lualine_b = {
                    "branch",
                    "filename",
                    {
                        "navic",
                        color_correction = "dynamic",
                        navic_opts = nil,
                    },
                },
                lualine_c = {},
                lualine_d = {
                    { "diagnostics", sources = { "nvim_lsp", "nvim_diagnostic" } },
                    "%=",
                },
                lualine_x = { "diff" },
                lualine_y = { "encoding", "fileformat", "filetype" },
                lualine_z = { "progress", "location" },
            },
            extensions = {},
        },
    },
}
