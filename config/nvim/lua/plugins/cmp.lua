return function()
    local cmp = require "cmp"
    local cmp_ultisnips_mappings = require "cmp_nvim_ultisnips.mappings"
    local lspkind = require "lspkind"
    local selectNext = function(fallback)
        if cmp.visible() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
        else
            fallback()
        end
    end
    local selectPrev = function(fallback)
        if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
        else
            fallback()
        end
    end
    local doNothing = function(fallback)
        fallback()
    end
    cmp.setup {
        completion = { completeopt = "menu,menuone,noselect" },
        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end,
        },

        mapping = {
            ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
            ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
            ["<Down>"] = cmp.mapping {
                c = doNothing,
                i = selectNext,
            },
            ["<Up>"] = cmp.mapping {
                c = doNothing,
                i = selectPrev,
            },
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = function(fallback)
                if cmp.get_selected_entry() then
                    cmp.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }
                elseif cmp.visible() then
                    cmp.close()
                else
                    fallback()
                end
            end,
            ["<Tab>"] = cmp.mapping {
                c = selectNext,
                i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                        cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
                    elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                        cmp_ultisnips_mappings.compose({ "jump_forwards" })(fallback)
                    else
                        fallback()
                    end
                end,
                s = function(fallback)
                    if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                        cmp_ultisnips_mappings.compose({ "jump_forwards" })(fallback)
                    else
                        fallback()
                    end
                end,
            },
            ["<S-Tab>"] = cmp.mapping {
                c = selectPrev,
                i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                        cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
                    elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                        cmp_ultisnips_mappings.jump_backwards(fallback)
                    else
                        fallback()
                    end
                end,
                s = function(fallback)
                    if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                        cmp_ultisnips_mappings.jump_backwards(fallback)
                    else
                        fallback()
                    end
                end,
            },
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
