return function()
    vim.opt.foldmethod = "expr"
    vim.opt.foldlevel = 3
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldminlines = 3
    vim.opt.foldnestmax = 5

    require("nvim-treesitter.install").prefer_git = true
    require("nvim-treesitter.configs").setup {
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
        autotag = {
            enable = true,
            filetypes = {
                "html",
                "javascript",
                "javascriptreact",
                "typescriptreact",
                "svelte",
                "vue",
                "xml",
            },
        },
        -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = {
            "lua",
            "python",
            "javascript",
            "json",
            "cpp",
            "cmake",
            "c",
            "java",
            "norg",
        },
        ignore_install = { "haskell" }, -- List of parsers to ignore installing
        highlight = {
            enable = true, -- false will disable the whole extension
            disable = {}, -- list of language that will be disabled
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
                    smart_rename = "grr",
                },
            },
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = "gnd",
                    list_definitions = "gnD",
                    list_definitions_toc = "gO",
                    goto_next_usage = "<a-*>",
                    goto_previous_usage = "<a-#>",
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
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
        },
    }
end
