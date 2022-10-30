return function()
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local lspkind = require 'lspkind'
    local cmp = require 'cmp'

    local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col == 0 then
            return false
        end
        local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        return current_line:sub(col, col):match '%w' ~= nil
    end
    cmp.setup {
        completion = { completeopt = 'menu,menuone,noselect' },
        snippet = {
            expand = function(args)
                vim.fn['vsnip#anonymous'](args.body)
            end,
        },
        mapping = {
            ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
            ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
            ['<Down>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
            ['<Up>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = function(fallback)
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
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn['vsnip#available'](1) == 1 then
                    feedkey('<Plug>(vsnip-expand-or-jump)', '')
                elseif has_words_before() then
                    cmp.complete()
                else
                    -- The fallback function sends a already mapped key.
                    -- In this case, it's probably `<Tab>`.
                    fallback()
                end
            end, { 'i', 's', 'c' }),
            ['<S-Tab>'] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn['vsnip#jumpable'](-1) == 1 then
                    feedkey('<Plug>(vsnip-jump-prev)', '')
                end
            end, { 'i', 's', 'c' }),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'comdline' },
            { name = 'treesitter' },
            { name = 'vsnip' },
            { name = 'doxygen' },
        }, {
            { name = 'buffer' },
        }),
        formatting = {
            format = lspkind.cmp_format {
                mode = 'symbol',
                maxwidth = 50,
                ellipsis_char = '...',
            },
        },
    }

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
        sources = {
            { name = 'buffer' },
        },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
            { name = 'path' },
        }, {
            { name = 'cmdline' },
        }),
    })
    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )
end
