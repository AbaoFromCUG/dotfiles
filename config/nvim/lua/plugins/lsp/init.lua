local function blink()
    ---@param ctx blink.cmp.CompletionRenderContext
    ---@return blink.cmp.Component
    local function render_item(ctx)
        return {
            {
                " " .. ctx.item.label,
                fill = true,
                -- hl_group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
            },
            { string.format(" %s%s%-10s", ctx.kind_icon, ctx.icon_gap, ctx.kind), hl_group = "BlinkCmpKind" .. ctx.kind },
            {
                string.format("[%s] ", ctx.item.source_name),
                hl_group = "BlinkCmpSource",
            },
        }
    end

    ---@diagnostic disable: missing-fields
    require("blink-cmp").setup({
        keymap = {
            ["<CR>"] = { "accept", "hide", "fallback" },
            ["<C-Space>"] = { "show" },
            ["<C-e>"] = { "show_documentation", "hide_documentation" },
            ["<C-d>"] = { "scroll_documentation_down" },
            ["<C-u>"] = { "scroll_documentation_up" },
            ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
            ["<Down>"] = { "snippet_forward", "select_next", "fallback" },
            ["<C-n>"] = { "snippet_forward", "select_next", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
            ["<Up>"] = { "snippet_backward", "select_prev", "fallback" },
            ["<C-p>"] = { "snippet_backward", "select_prev", "fallback" },
        },
        windows = {
            autocomplete = {
                selection = "manual",
                draw = render_item,
            },
            documentation = {
                auto_show = true,
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
            null_ls.builtins.formatting.typstfmt,
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
    {
        "j-hui/fidget.nvim",
        config = true,
        event = "VeryLazy",
    },
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
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
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
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
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
