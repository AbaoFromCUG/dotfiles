return function()
    local cmp = require "cmp"
    local cmp_ultisnips_mappings = require "cmp_nvim_ultisnips.mappings"
    local lspkind = require "lspkind"
    cmp.setup {
        completion = { completeopt = "menu,menuone,noinsert" },
        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end,
        },
        -- Intellij-like mapping
        mapping = {
            ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
            ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
            ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
            ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },

            ["<Tab>"] = cmp.mapping(function(fallback)
                -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
                if cmp.visible() then
                    local entry = cmp.get_selected_entry()
                    if not entry then
                        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                    end
                    cmp.confirm()
                else
                    fallback()
                end
            end, { "i", "s", "c" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                cmp_ultisnips_mappings.jump_backwards(fallback)
            end, { "i", "s" }),
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
            { name = "comdline" },
            { name = "treesitter" },
            { name = "ultisnips" },
        }, {
            { name = "buffer" },
        }),
        formatting = {
            format = lspkind.cmp_format {
                with_text = true,
                menu = {
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[Latex]",
                    ultisnips = "[Ultisnips]",
                },
            },
        },
    }
    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline("/", {
        sources = {
            { name = "buffer" },
        },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })
    -- you need setup cmp first put this after cmp.setup()
    -- require("nvim-autopairs.completion.cmp").setup({
    --   map_cr = true, --  map <CR> on insert mode
    --   map_complete = true, -- it will auto insert `(` after select function or method item
    --   auto_select = true -- automatically select the first item
    -- })
    -- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end
