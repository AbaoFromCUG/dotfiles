return function()
    -- consult nvim-ufo
    -- vim.opt.foldmethod = 'expr'
    -- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    -- vim.opt.foldenable = false

    vim.treesitter.language.register('qmljs', 'qml')

    require 'nvim-treesitter.install'.prefer_git = true
    local parser_path = vim.fn.stdpath 'data' .. '/ts-parsers'
    vim.opt.runtimepath:append(parser_path)

    require 'nvim-treesitter.configs'.setup {
        parser_install_dir = parser_path,
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = 'gnn',
                node_incremental = 'grn',
                scope_incremental = 'grc',
                node_decremental = 'grm',
            },
        },
        -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = {
            'vim',
            'lua',
            'python',
            'javascript',
            'typescript',
            'c',
            'cpp',
            'cmake',
            'java',
            'qmljs',
            'bash',
            'json',
            'markdown',
            'markdown_inline',
            'norg',
            'html',
            'css',
            'vue',
            'latex',
            'regex',
        },
        highlight = {
            enable = true, -- false will disable the whole extension
        },
        autopairs = {
            enable = true,
        },
        matchup = { enable = true },
        rainbow = {
            enable = true,
            extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
            -- max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        },
        refactor = {
            highlight_definitions = { enable = true },
            highlight_current_scope = { enable = false },
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = 'grr',
                },
            },
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = 'gnd',
                    list_definitions = 'gnD',
                    list_definitions_toc = 'gO',
                    goto_next_usage = '<a-*>',
                    goto_previous_usage = '<a-#>',
                },
            },
        },
        textobjects = {
            select = {
                enable = true,
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                    -- You can optionally set descriptions to the mappings (used in the desc parameter of
                    -- nvim_buf_set_keymap) which plugins like which-key display
                        ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
                },
            },
            include_surrounding_whitespace = true,
        },
    }
end
