return function()
    local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

    local cmp = require "cmp"
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
    local selectNextOrSnippet = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
        elseif vim.fn["vsnip#available"](1) == 1 then
            feedkey("<Plug>(vsnip-jump-next)", "")
        else
            fallback()
        end
    end
    local selectPrevOrSnippet = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
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
                vim.fn["vsnip#anonymous"](args.body)
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
                i = selectNextOrSnippet,
                s = selectNextOrSnippet,
            },
            ["<S-Tab>"] = cmp.mapping {
                c = selectPrev,
                i = selectPrevOrSnippet,
                s = selectPrevOrSnippet,
            },
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
            { name = "comdline" },
            { name = "treesitter" },
            { name = "vsnip" },
            { name = "orgmode" },
        }, {
            { name = "buffer" },
        }),
        formatting = {
            format = lspkind.cmp_format {
                with_text = true,
                menu = {
                    nvim_lsp = "[lsp]",
                    buffer = "[buffer]",
                    path = "[path]",
                    nvim_lua = "[lua]",
                    latex_symbols = "[latex]",
                    vsnip = "[vsnip]",
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
end
