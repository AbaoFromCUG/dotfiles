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
        -- matchup = {
        --     enable = true,
        -- },
        -- pairs = {
        --     enable = true,
        --     disable = {},
        --     highlight_pair_events = {}, -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
        --     highlight_self = false, -- whether to highlight also the part of the pair under cursor (or only the partner)
        --     goto_right_end = false, -- whether to go to the end of the right partner or the beginning
        --     fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
        --     keymaps = {
        --         goto_partner = "<leader>%",
        --         delete_balanced = "X",
        --     },
        --     delete_balanced = {
        --         only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
        --         fallback_cmd_normal = nil, -- fallback command when no pair found, can be nil
        --         longest_partner = false, -- whether to delete the longest or the shortest pair when multiple found.
        --         -- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
        --     },
        -- },
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
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = "<space>cs",
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
                    ["]f"] = { query = "@function.outer", desc = "next function start" },
                    ["]c"] = { query = "@class.outer", desc = "next class start" },
                    ["]j"] = { query = "@cellcontent", desc = "previous cell content" },
                },
                goto_previous_start = {
                    ["[f"] = { query = "@function.outer", desc = "previous function start" },
                    ["[c"] = { query = "@class.outer", desc = "previous class start" },
                    ["[j"] = { query = "@cellcontent", desc = "previous cell content" },
                },
            },
            include_surrounding_whitespace = true,
        },
    })
end
