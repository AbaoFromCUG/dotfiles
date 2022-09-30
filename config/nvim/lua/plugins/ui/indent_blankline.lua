return function()
    local filetype_exclude = {
            'startify', 'dashboard', 'dotooagenda', 'log', 'fugitive',
            'gitcommit', 'packer', 'vimwiki', 'markdown', 'txt',
            'vista', 'help', 'todoist', 'NvimTree', 'peekaboo', 'git',
            'TelescopePrompt', 'undotree', 'flutterToolsOutline', '' -- for all buffers without a file type
    }
    local indent_blankline = require 'indent_blankline'
    indent_blankline.setup {
        show_first_indent_level = false,
        filetype_exclude = filetype_exclude,
        buftype_exclude = { 'terminal', 'nofile' },
        space_char_blankline = ' ',
        show_trailing_blankline_indent = false,
    }
end
