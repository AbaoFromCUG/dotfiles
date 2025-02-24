return function()
    vim.treesitter.language.register("qmljs", "qml")
    vim.treesitter.language.register("bash", "kitty")

    require("nvim-treesitter.install").prefer_git = true
    local parser_path = vim.fn.stdpath("data") .. "/ts-parsers"
    vim.opt.runtimepath:append(parser_path)

    vim.api.nvim_set_hl(0, "@attribute_ref_value.vue", { link = "@variable" })
    vim.filetype.add({
        extension = {
            rasi = "rasi",
            rofi = "rasi",
            wofi = "rasi",
            qml = "qml",
            wgsl = "wgsl",
            pdfpc = "json",
        },
        filename = {
            ["vifmrc"] = "vim",
            ["justfile"] = "just",
        },
        pattern = {
            ["**/.vscode/*.json"] = "jsonc",
            [".*/waybar/config"] = "jsonc",
            [".*/mako/config"] = "dosini",
            [".*/kitty/.+%.conf"] = "kitty",
            [".*/hypr/.+%.conf"] = "hyprlang",
            ["%.env%.[%w_.-]+"] = "sh",
        },
    })

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
            -- "javascript",
            "latex",
        },
        parser_install_dir = parser_path,
        -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = {
            "jsdoc",
            "markdown_inline",
            "wgsl",
            "regex",
            "comment",
            "gitcommit",
        },
        modules = {},
        highlight = {
            enable = true, -- false will disable the whole extension
        },
        indent = {
            enable = true,
        },
        endwise = {
            enable = true,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = { query = "@function.outer", desc = "function outer" },
                    ["if"] = { query = "@function.inner", desc = "function innner" },
                    ["ac"] = { query = "@class.outer", desc = "class outer" },
                    ["ic"] = { query = "@class.inner", desc = "class inner" },

                    ["aj"] = { query = "@cell", desc = "cell outer" },
                    ["ij"] = { query = "@cellcontent", desc = "cell inner" },
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]f"] = { query = "@function.outer", desc = "function start" },
                    ["]c"] = { query = "@class.outer", desc = "class start" },
                    ["]z"] = { query = "@fold", query_group = "folds", desc = "fold" },
                    ["]j"] = { query = "@cellseparator", desc = "cell separator" },
                },
                goto_previous_start = {
                    ["[f"] = { query = "@function.outer", desc = "function start" },
                    ["[c"] = { query = "@class.outer", desc = "class start" },
                    ["[z"] = { query = "@fold", query_group = "folds", desc = "fold" },
                    ["[j"] = { query = "@cellseparator", desc = "cell separator" },
                },
            },
            include_surrounding_whitespace = true,
        },
    })
end
