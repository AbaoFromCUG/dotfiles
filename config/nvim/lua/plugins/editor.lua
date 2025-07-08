local function surround()
    local config = require("nvim-surround.config")
    local lang2add = {
        ["lua"] = function(text) return { { "function " .. text .. "()" }, { "end" } } end,
        ["python"] = function(text) return { { "def " .. text .. "():", "" }, { "", "" } } end,
        ["default"] = function(text) return { { "function " .. text .. "() {" }, { "}" } } end,
    }

    require("nvim-surround").setup({
        keymaps = {
            visual = "ys",
        },
        surrounds = {
            ["F"] = {
                add = function()
                    local result = config.get_input("Enter the function name: ")
                    if result then
                        local lang = vim.bo.filetype
                        local handler = lang2add[lang] or lang2add["default"]
                        return handler(result)
                    end
                end,
                find = function()
                    return config.get_selection({
                        query = {
                            capture = "@function.outer",
                            type = "textobjects",
                        },
                    })
                end,
                delete = function()
                    local outer_selection = config.get_selection({
                        query = {
                            capture = "@function.outer",
                            type = "textobjects",
                        },
                    })
                    local inner_selection = config.get_selection({
                        query = {
                            capture = "@function.inner",
                            type = "textobjects",
                        },
                    })
                    if not outer_selection or not inner_selection then
                        vim.notify("Couldn't find function outline to delete", vim.log.levels.ERROR)
                        return
                    end

                    local selections = {
                        left = {
                            first_pos = outer_selection.first_pos,
                            last_pos = { inner_selection.first_pos[1], inner_selection.first_pos[2] - 1 },
                        },
                        right = {
                            first_pos = { inner_selection.last_pos[1], inner_selection.last_pos[2] + 1 },
                            last_pos = outer_selection.last_pos,
                        },
                    }
                    return selections
                end,
            },
        },
    })
end


local function gitsigns()
    local gs = require("gitsigns")
    gs.setup({
        current_line_blame = true,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 100,
            ignore_whitespace = false,
        },
        on_attach = function(bufnr)
            require("which-key").add({
                { mode = { "n", "v" }, "g",                                group = "git" },
                -- Navigation
                { "]h",                "<cmd>Gitsigns next_hunk<cr>",      desc = "next hunk" },
                { "[h",                "<cmd>Gitsigns prev_hunk<cr>",      desc = "prev hunk" },

                -- Actions
                { "<leader>gh",        desc = "git operation" },
                { mode = "n",          "<leader>ghs",                      gs.stage_hunk,                                                             desc = "stage hunk" },
                { mode = "v",          "<leader>ghs",                      function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,      desc = "stage hunk" },

                { mode = "n",          "<leader>ghu",                      gs.undo_stage_hunk,                                                        desc = "unstage hunk" },
                { mode = "v",          "<leader>ghu",                      function() gs.undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, desc = "unstage hunk" },

                { mode = "n",          "<leader>ghr",                      gs.reset_hunk,                                                             desc = "reset hunk" },
                { mode = "v",          "<leader>ghr",                      function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,      desc = "reset hunk" },

                { mode = "n",          "<leader>ghS",                      gs.stage_buffer,                                                           desc = "stage buffer" },
                { mode = "n",          "<leader>ghR",                      gs.reset_buffer,                                                           desc = "reset buffer" },

                -- view
                { "<leader>gtb",       "<cmd>Gitsigns blame<CR>",          desc = "toggle blame" },
                { "<leader>gtt",       "<cmd>Gitsigns diffthis<CR>",       desc = "diff this" },
                { "<leader>gtD",       "<cmd>Gitsigns diffthis ~<CR>",     desc = "diff last commit" },
                { "<leader>gtd",       "<cmd>Gitsigns toggle_deleted<CR>", desc = "reset hunk" },

                -- Text object
                { "ih",                ":<C-U>Gitsigns select_hunk<CR>",   desc = "reset hunk",                                                       mode = "o" },
                { "ih",                ":<C-U>Gitsigns select_hunk<CR>",   desc = "reset hunk",                                                       mode = "x" },
                buffer = bufnr,
            })
        end,
    })
end

local function session()
    require("session").setup({ silent_restore = false })
    require("session").register_hook("pre_save", "close_all_floating_wins", function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
                vim.api.nvim_win_close(win, false)
            end
        end
    end)
end

local function comment()
    ---@diagnostic disable-next-line: missing-fields
    require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
end

local languages = {
    "jsdoc",
    "markdown_inline",
    "wgsl",
    "regex",
    "comment",
    "gitcommit",
    "python",
    "typescript",
    "tsx",
    "javascript",
    "jsx",
    "vue",
    "yaml",
    "json",
    "html",
    "xml",
    "toml",
}

---@type LazySpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            install_dir = vim.fn.stdpath("data") .. "/ts-parsers",
        },
        branch = "main",
        lazy = false
    },
    {
        "AbaoFromCUG/nvim-treesitter-endwise",
        branch = "main",
        event = "LazyFile",
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        opts = {
            select = {
                enable = true,
                lookahead = true,
                selection_modes = {
                    ["@parameter.outer"] = "v", -- charwise
                    ["@function.outer"] = "V",  -- linewise
                    ["@class.outer"] = "<c-v>", -- blockwise
                },
            },
            move = {
                enable = true,
                set_jumps = true,
            },

            include_surrounding_whitespace = true,
        },
        keys = vim.iter(vim.iter({
            select = {
                ["af"] = { query = "@function.outer", desc = "function outer" },
                ["if"] = { query = "@function.inner", desc = "function innner" },
                ["ac"] = { query = "@class.outer", desc = "class outer" },
                ["ic"] = { query = "@class.inner", desc = "class inner" },

                ["aj"] = { query = "@cell", desc = "cell outer" },
                ["ij"] = { query = "@cellcontent", desc = "cell inner" },

                ["as"] = { query = "@local.scope", desc = "locals" },
            },
            move = {
                goto_next_start = {
                    ["]f"] = { query = "@function.outer", desc = "function start" },
                    ["]c"] = { query = "@class.outer", desc = "class start" },
                    ["]z"] = { query = "@fold", query_group = "folds", desc = "fold" },
                    ["]j"] = { query = { "@cellseparator.code", "@cellseparator.markdown", "@cellseparator.raw" }, desc = "cell separator" },
                },
                goto_previous_start = {
                    ["[f"] = { query = "@function.outer", desc = "function start" },
                    ["[c"] = { query = "@class.outer", desc = "class start" },
                    ["[z"] = { query = "@fold", query_group = "folds", desc = "fold" },
                    ["[j"] = { query = { "@cellseparator.code", "@cellseparator.markdown", "@cellseparator.raw" }, desc = "cell separator" },
                },
            },
        }):map(function(feat, v)
            if feat == "select" then
                return vim.iter(v):map(function(key, opts)
                    return {
                        key,
                        function()
                            require("nvim-treesitter-textobjects.select").select_textobject(opts.query, "textobjects")
                        end,
                        desc = opts.desc,
                        mode = { "x", "o" }
                    }
                end):totable()
            end
            if feat == "move" then
                local bb = vim.iter(pairs(v)):map(function(func, maps)
                    return vim.iter(maps):map(function(key, opts)
                        return {
                            key,
                            function()
                                require("nvim-treesitter-textobjects.move")[func](opts.query, "textobjects")
                            end,
                            desc = opts.desc,
                            mode = { "n", "x", "o" }
                        }
                    end):totable()
                end):totable()
                return vim.iter(bb):flatten():totable()
            end
            return {}
        end):totable()):flatten():totable()
    },
    {
        "MeanderingProgrammer/treesitter-modules.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            ensure_installed = languages,
            fold = { enable = true },
            highlight = { enable = true },
            indent = { enable = true },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
        },
        event = "VeryLazy"
    },

    {
        "windwp/nvim-ts-autotag",
        opts = { opts = { enable_close_on_slash = true } },
        event = "LazyFile",
    },
    {
        "monkoose/matchparen.nvim",
        opts = {
            -- config
        },
        init = function()
            -- `matchparen.vim` needs to be disabled manually in case of lazy loading
            vim.g.loaded_matchparen = 1
        end,
        event = "LazyFile",
    },
    {
        "nvim-treesitter-context",
        opts = { max_lines = 1 },
        dependencies = {
            "nvim-treesitter",
        },
        event = "LazyFile",
    },
    -- autopairs
    {
        "windwp/nvim-autopairs",
        opts = {
            check_ts = true,
        },
        event = "InsertEnter",
    },
    -- fold
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        event = "VeryLazy",
        opts = {
            provider_selector = function() return { "treesitter", "indent" } end,
        },
        keys = {
            { "zR", function() require("ufo").openAllFolds() end,  desc = "Open all folds" },
            { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
        },
    },
    -- surround edit
    {
        "kylechui/nvim-surround",
        event = "LazyFile",
        dependencies = {
            "nvim-treesitter",
            "nvim-treesitter-textobjects",
        },
        config = surround,
    },
    -- annotation gen
    {
        "danymat/neogen",
        opts = { snippet_engine = "nvim" },
        cmd = "Neogen",
        keys = {
            { "<space>cn", "<cmd>Neogen<cr>",       desc = "neogen" },
            { "<space>cf", "<cmd>Neogen func<cr>",  desc = "neogen function" },
            { "<space>cc", "<cmd>Neogen class<cr>", desc = "neogen class" },
            { "<space>ct", "<cmd>Neogen type<cr>",  desc = "neogen type" },
        },
    },

    -- comment
    {
        "numToStr/Comment.nvim",
        config = comment,
        event = "LazyFile",
    },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    -- git
    {
        "lewis6991/gitsigns.nvim",
        config = gitsigns,
        event = "VeryLazy",
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen" },
    },
    {
        "NeogitOrg/neogit",
        config = true,
        cmd = { "Neogit" },
    },
    -- keymap
    {
        "folke/which-key.nvim",
        config = true,
        event = "VeryLazy",
    },

    {
        "folke/flash.nvim",
        ---@type Flash.Config
        opts = {
            modes = {
                search = {
                    enabled = true
                }
            }
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function() require("flash").jump() end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc = "Toggle Flash Search",
            },
        },
        event = "VeryLazy"
    },

    -- session & project
    {
        "AbaoFromCUG/session.nvim",
        config = session,
        event = "VeryLazy",
    },
    {
        "folke/neoconf.nvim",
        config = true,
        keys = {
            { "<leader>,,", "<cmd>Neoconf local<cr>", desc = "local settings" },
        },
    },
    {
        "nvim-pack/nvim-spectre",
        config = true,
        cmd = "Spectre",
        keys = {
            { mode = "n", "<leader>ss", '<cmd>lua require("spectre").toggle()<cr>',                             desc = "toggle spectre" },
            { mode = "n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<cr>',      desc = "search current word" },
            { mode = "v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<cr>',                   desc = "search current word" },
            { mode = "n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<cr>', desc = "search on current file" },
        },
    },
    {
        "ThePrimeagen/refactoring.nvim",
        opts = {},
        keys = {


            { "<space>crr",  function() require("refactoring").select_refactor() end, desc = "refactor",         mode = { "n", "x" } },
            { "<space>cre",  "<cmd>Refactor extract<cr>",                             desc = "extract",          mode = { "n", "x" } },
            { "<space>crf",  "<cmd>Refactor extract_to_file<cr>",                     desc = "extract to file",  mode = { "n", "x" } },
            { "<space>crv",  "<cmd>Refactor extract_var<cr>",                         desc = "extract variable", mode = { "n", "x" } },
            { "<space>crV",  "<cmd>Refactor inline_var<cr>",                          desc = "inline variable",  mode = { "n", "x" } },
            { "<space>crf",  "<cmd>Refactor extract_func<cr>",                        desc = "extract function", mode = { "n", "x" } },
            { "<space>crF",  "<cmd>Refactor inline_func<cr>",                         desc = "line function",    mode = { "n", "x" } },
            { "<space>crbb", "<cmd>Refactor extract_block<cr>",                       desc = "extract",          mode = { "n", "x" } },
            { "<space>crbf", "<cmd>Refactor extract_block_to_file<cr>",               desc = "extract",          mode = { "n", "x" } },
        },
        cmd = "Refactor"
    },
    {
        "smjonas/live-command.nvim",
        opts = {
            commands = {
                Norm = { cmd = "norm" },
            },
        },
        cmd = { "Norm" },
    },
    {
        "nvimdev/template.nvim",
        cmd = "Template"
    },
    {
        "jake-stewart/multicursor.nvim",
        config = function()
            local mc = require("multicursor-nvim")

            mc.setup()

            -- use MultiCursorCursor and MultiCursorVisual to customize
            -- additional cursors appearance
            vim.cmd.hi("link", "MultiCursorCursor", "Cursor")
            vim.cmd.hi("link", "MultiCursorVisual", "Visual")

            vim.keymap.set("n", "<esc>", function()
                if mc.hasCursors() then
                    mc.clearCursors()
                else
                    -- default <esc> handler
                end
            end)

            -- add cursors above/below the main cursor
            vim.keymap.set("n", "<up>", function() mc.addCursor("k") end)
            vim.keymap.set("n", "<down>", function() mc.addCursor("j") end)

            -- add a cursor and jump to the next word under cursor
            vim.keymap.set("n", "<c-n>", function() mc.addCursor("*") end)

            -- jump to the next word under cursor but do not add a cursor
            vim.keymap.set("n", "<c-s>", function() mc.skipCursor("*") end)

            -- add and remove cursors with control + left click
            vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
        end,
    },
}
