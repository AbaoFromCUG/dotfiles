return function()
    local lspkind = require("lspkind")
    local cmp = require("cmp")
    local function smart_tab(fallback)
        if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        else
            fallback()
        end
    end
    local function smart_shift_tab(fallback)
        if cmp.visible() then
            -- cmp.select_({ behavior = cmp.SelectBehavior.Insert })
        else
            fallback()
        end
    end

    cmp.setup({
        preselect = cmp.PreselectMode.Item,
        completion = { completeopt = "menu,menuone,noselect" },
        snippet = {
            expand = function(args)
                vim.snippet.expand(args.body)
            end,
        },
        sorting = {
            priority_weight = 2,
            comparators = {
                function(entry1, entry2)
                    if entry1.completion_item.preselect ~= entry2.completion_item.preselect then
                        return false
                    end
                    return nil
                end,
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                require("cmp-under-comparator").under,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = function(fallback)
                if cmp.get_selected_entry() then
                    cmp.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    })
                elseif cmp.visible() then
                    cmp.abort()
                else
                    fallback()
                end
            end,
            ["<Tab>"] = cmp.mapping({
                i = smart_tab,
                c = smart_tab,
                n = function(fallback)
                    if vim.snippet.active({ direction = 1 }) then
                        vim.snippet.jump(1)
                    else
                        fallback()
                    end
                end,
            }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                -- elseif luasnip.jumpable(-1) then
                --     luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s", "c" }),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "snippets" },
            -- { name = "neopyter", option = { completers = { "CompletionProvider:kernel" } } },
            { name = "neopyter" },
            { name = "vimtex" },
        }, {
            { name = "buffer" },
        }),
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol_text",
                maxwidth = 50,
                ellipsis_char = "...",
                menu = {
                    nvim_lsp = "[LSP]",
                    buffer = "[Buffer]",
                    path = "[Path]",
                    cmdline = "[Cmdline]",
                    doxygen = "[Doxygen]",
                    snippets = "[Snippet]",
                    neopyter = "[Neopyter]",
                },
                symbol_map = {
                    ["String"] = "󰉿",
                    ["Magic"] = "",
                    ["Path"] = "󰉋",
                    ["Dict key"] = "󰌋",
                    ["Instance"] = "󱃻",
                    ["Statement"] = "󱇯",
                },
                before = require("tailwindcss-colorizer-cmp").formatter,
            }),
        },
    })

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
