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

local is_inside_work_tree = {}

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
                { mode = { "n", "v" }, "g", group = "git" },
                -- Navigation
                { "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "next hunk" },
                { "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "prev hunk" },

                -- Actions
                { "<leader>gh", desc = "git operation" },
                { mode = "n", "<leader>ghs", gs.stage_hunk, desc = "stage hunk" },
                { mode = "v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, desc = "stage hunk" },

                { mode = "n", "<leader>ghu", gs.undo_stage_hunk, desc = "unstage hunk" },
                { mode = "v", "<leader>ghu", function() gs.undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, desc = "unstage hunk" },

                { mode = "n", "<leader>ghr", gs.reset_hunk, desc = "reset hunk" },
                { mode = "v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, desc = "reset hunk" },

                { mode = "n", "<leader>ghS", gs.stage_buffer, desc = "stage buffer" },
                { mode = "n", "<leader>ghR", gs.reset_buffer, desc = "reset buffer" },

                -- view
                { "<leader>gtb", "<cmd>Gitsigns blame<CR>", desc = "toggle blame" },
                { "<leader>gtt", "<cmd>Gitsigns diffthis<CR>", desc = "diff this" },
                { "<leader>gtD", "<cmd>Gitsigns diffthis ~<CR>", desc = "diff last commit" },
                { "<leader>gtd", "<cmd>Gitsigns toggle_deleted<CR>", desc = "reset hunk" },

                -- Text object
                { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "reset hunk", mode = "o" },
                { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "reset hunk", mode = "x" },
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
    require("session").register_hook("post_restore", "restore_breakpoints", function()
        local persistent_bp = require("persistent-breakpoints.api")
        persistent_bp.load_breakpoints()
        require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp" } })
    end)
    require("session").register_hook("post_restore", "restore_nvim_tree", function()
        local tree_api = require("nvim-tree.api")
        tree_api.tree.change_root(vim.fn.getcwd())
        tree_api.tree.reload()
    end)
    require("session").register_hook("pre_save", "close_nvim_tree", function()
        local tree_api = require("nvim-tree.api")
        tree_api.tree.close()
    end)
end

local function comment()
    ---@diagnostic disable-next-line: missing-fields
    require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
end

---@type LazySpec[]
return {
    -- tree-sitter highlight
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = require("plugins.editor.treesitter"),
        dependencies = {
            { "metiulekm/nvim-treesitter-endwise" },
            { "nvim-treesitter/nvim-treesitter-textobjects" },
        },
        event = "VeryLazy",
    },
    {
        "windwp/nvim-ts-autotag",
        opts = { opts = { enable_close_on_slash = true } },
        event = "VeryLazy",
    },

    {
        "monkoose/matchparen.nvim",
        event = "VeryLazy",
        opts = {
            -- config
        },
        init = function()
            -- `matchparen.vim` needs to be disabled manually in case of lazy loading
            vim.g.loaded_matchparen = 1
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = { max_lines = 1 },
        dependencies = {
            "nvim-treesitter",
        },
        event = "VeryLazy",
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
            { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
            { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
        },
    },
    -- surround edit
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = surround,
    },
    -- annotation gen
    {
        "danymat/neogen",
        opts = { snippet_engine = "nvim" },
        cmd = "Neogen",
        keys = {
            { "<space>cn", "<cmd>Neogen<cr>", desc = "neogen" },
            { "<space>cf", "<cmd>Neogen func<cr>", desc = "neogen function" },
            { "<space>cc", "<cmd>Neogen class<cr>", desc = "neogen class" },
            { "<space>ct", "<cmd>Neogen type<cr>", desc = "neogen type" },
        },
    },

    -- comment
    { "numToStr/Comment.nvim", config = comment, event = "VeryLazy" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
        event = "VeryLazy",
    },
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
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function() require("flash").jump() end,
                desc = "Flash",
            },
            {
                "F",
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
            { mode = "n", "<leader>ss", '<cmd>lua require("spectre").toggle()<cr>', desc = "toggle spectre" },
            { mode = "n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<cr>', desc = "search current word" },
            { mode = "v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<cr>', desc = "search current word" },
            { mode = "n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<cr>', desc = "search on current file" },
        },
    },
    {
        "ThePrimeagen/refactoring.nvim",
        opts = {},
        keys = {
            { "<space>cr", "<cmd>lua require('refactoring').select_refactor()<cr>", desc = "refactor" },
        },
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
