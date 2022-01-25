return function()
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.org = {
        install_info = {
            url = "https://github.com/milisims/tree-sitter-org",
            revision = "f110024d539e676f25b72b7c80b0fd43c34264ef",
            files = { "src/parser.c", "src/scanner.cc" },
        },
        filetype = "org",
    }
    require("nvim-treesitter.configs").setup {
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
        ensure_installed = { "lua", "python", "javascript", "json", "cpp", "cmake", "c", "java", "org" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
