return function()
    local code_navigation = require 'nvim-navic'
    local launcher = require 'launcher'
    require 'lualine'.setup {
        options = {
            icons_enabled = true,
            icon_only = true,
            theme = 'gruvbox',
            component_separators = { '', '' },
            section_separators = { '', '' },
            disabled_filetypes = {},
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = {
                'filename', 'diff', { launcher.current_display_name, cond = launcher.is_available }
            },
            lualine_c = { { code_navigation.get_location, cond = code_navigation.is_available } },
            lualine_x = { 'lsp_progress', 'diagnostics' },
            lualine_y = { 'encoding', 'fileformat', 'filetype' },
            lualine_z = { 'progress', 'location' },
        },
        extensions = {},
    }
end
