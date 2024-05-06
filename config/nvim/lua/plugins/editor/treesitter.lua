return function()
    -- consult nvim-ufo
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false

    vim.treesitter.language.register("qmljs", "qml")
    -- vim.treesitter.language.register("typescript", "javascript")
    -- vim.treesitter.language.register("typescript", "javascriptreact")

    require("nvim-treesitter.install").prefer_git = true
    local parser_path = vim.fn.stdpath("data") .. "/ts-parsers"
    vim.opt.runtimepath:append(parser_path)

    vim.api.nvim_set_hl(0, "@attribute_ref_value.vue", { link = "@variable" })

    require("nvim-treesitter.configs").setup({
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
        sync_install = false,
        auto_install = true,
        ignore_install = {
            "javascript",
        },
        parser_install_dir = parser_path,
        -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = {
            "vim",
            "vimdoc",
            "lua",
            "python",
            "typescript",
            "c",
            "cpp",
            "rust",
            "cmake",
            "java",
            "qmljs",
            "bash",
            "json",
            "jsonc",
            "markdown",
            "markdown_inline",
            "norg",
            "html",
            "css",
            "vue",
            "tsx",
            "latex",
            "wgsl",
            "regex",
        },
        modules = {},
        highlight = {
            enable = true, -- false will disable the whole extension
            disable = function(lang, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 1000
            end,
        },
        indent = {
            enable = true,
        },
        autopairs = {
            enable = true,
        },
        autotag = {
            enable = true,
        },
        endwise = {
            enable = true,
        },
        matchup = {
            enable = true,
            filetypes = {
                "html",
                "xml",
                "typescript",
                "typescriptreact",
                "javascript",
                "tsx",
                "javascriptreact",
            },
        },
        refactor = {
            highlight_definitions = { enable = true },
            highlight_current_scope = { enable = false },
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
                    -- You can optionally set descriptions to the mappings (used in the desc parameter of
                    -- nvim_buf_set_keymap) which plugins like which-key display
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                },
            },
            move = {
                enable = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = { query = "@class.outer", desc = "Next class start" },
                    ["]j"] = { query = "@cellseparator", desc = "Next cell separator" },
                    ["]c"] = { query = "@cellcontent", desc = "Next cell content" },
                },
                goto_previous_start = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                    ["[j"] = "@cellseparator",
                    ["[c"] = { "@cellcontent" },
                },
            },
            include_surrounding_whitespace = true,
        },
    })
end
