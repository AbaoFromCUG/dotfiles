local function blink()
    local utils = require("blink.cmp.utils")
    local source_map = {
        Snippets = "Snip",
        LSP = "LSP",
        Buffer = "Buf",
        Path = "Path",
    }

    ---@type blink.cmp.DrawComponent
    local source_component = {
        ---@param ctx blink.cmp.DrawItemContext
        text = function(ctx) return string.format("[%s] ", source_map[ctx.item.source_name] or ctx.item.source_name) end,
    }

    ---@diagnostic disable: missing-fields
    require("blink-cmp").setup({
        keymap = {
            ["<CR>"] = { "accept", "hide", "fallback" },
            ["<C-Space>"] = { "show" },
            ["<C-e>"] = { "show_documentation", "hide_documentation" },
            ["<C-d>"] = { "scroll_documentation_down" },
            ["<C-u>"] = { "scroll_documentation_up" },
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
        },
        highlight = {
            use_nvim_cmp_as_default = true,
        },
        windows = {
            autocomplete = {
                selection = "manual",
                -- draw = render_item,
                draw = {
                    padding = { 1, 0 },
                    columns = { { "label" }, { "kind_icon", "kind" }, { "label_description" }, { "source" } },
                    components = {
                        source = source_component,
                    },
                },
            },
            documentation = {
                auto_show = true,
            },
            ghost_text = {
                enabled = true,
            },
        },
        -- experimental auto-brackets support
        accept = { auto_brackets = { enabled = true } },

        -- experimental signature help support
        trigger = { signature_help = { enabled = true } },
    })
    ---@diagnostic enable: missing-fields
end

local function none_ls()
    local null_ls = require("null-ls")
    null_ls.setup({
        debug = true,
        sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.shfmt,

            null_ls.builtins.diagnostics.markdownlint,
            null_ls.builtins.diagnostics.qmllint,
            null_ls.builtins.diagnostics.cmake_lint,

            null_ls.builtins.formatting.markdownlint,
            null_ls.builtins.formatting.qmlformat,
            null_ls.builtins.formatting.cmake_format,
            null_ls.builtins.formatting.typstyle,
        },
    })
end

---@type LazySpec[]
return {
    {
        "neovim/nvim-lspconfig",
        config = require("plugins.lsp.lspconfig"),
        dependencies = {
            "neoconf.nvim",
        },
        event = { "LazyFile" },
    },

    -- completion engine
    {
        "saghen/blink.cmp",
        lazy = false,
        -- event = "VeryLazy",
        -- version = "v0.*",
        build = "cargo build --release",
        dependencies = "rafamadriz/friendly-snippets",
        config = blink,
    },

    -- lsp progress
    -- {
    --     "j-hui/fidget.nvim",
    --     config = true,
    --     event = "VeryLazy",
    -- },
    -- diagnostic list
    {
        "folke/trouble.nvim",
        opts = {},
        keys = {
            { "<leader>cx", "<cmd>Trouble diagnostics toggle<cr>", desc = "diagnostics" },
            { "<leader>cX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "buffer diagnostics" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "symbols" },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "lsp definitions/references" },
            { "<leader>cL", "<cmd>Trouble loclist toggle<cr>", desc = "location list" },
            { "<leader>cQ", "<cmd>Trouble qflist toggle<cr>", desc = "quickfix list" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        ---@diagnostic disable-next-line: missing-fields, missing-parameter
                        require("trouble").prev({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then vim.notify(err, vim.log.levels.ERROR) end
                    end
                end,
                desc = "Previous Trouble/Quickfix Item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        ---@diagnostic disable-next-line: missing-fields, missing-parameter
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then vim.notify(err, vim.log.levels.ERROR) end
                    end
                end,
                desc = "Next Trouble/Quickfix Item",
            },
        },
    },
    {
        "jmbuhr/otter.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            lsp = {
                diagnostic_update_events = { "TextChanged" },
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        config = none_ls,
        event = "VeryLazy",
    },
    "b0o/schemastore.nvim",
    {
        "AbaoFromCUG/lua_ls.nvim",
        ---@type lua_ls.Config
        opts = {
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                    },
                    diagnostics = {},
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                    format = {
                        enable = false,
                    },
                    completion = {
                        autoRequire = true,
                        callSnippet = "Replace",
                    },
                },
            },
        },
        ft = "lua",
        dev = true,
    },
}
