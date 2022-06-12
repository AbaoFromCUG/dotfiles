return function()
    local gps = require "nvim-gps"
    local function tab_spaces()
        local tabstop = vim.api.nvim_get_option "tabstop"
        if vim.opt.expandtab then
            return "Spaces:" .. tabstop
        else
            return "Tab Size" .. tabstop
        end
    end

    require("lualine").setup {
        options = {
            icons_enabled = true,
            theme = "gruvbox",
            component_separators = { "", "" },
            section_separators = { "", "" },
            disabled_filetypes = {},
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff" },
            lualine_c = { "filename", { gps.get_location, cond = gps.is_available } },
            lualine_x = { "lsp_progress", "diagnostics" },
            lualine_y = { tab_spaces, "encoding", "fileformat", "filetype" },
            lualine_z = { "progress", "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        extensions = {},
    }
end
