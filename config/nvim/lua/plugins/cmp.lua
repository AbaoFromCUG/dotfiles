return function()
    local cmp = require "cmp"
    local lspkind = require "lspkind"
    local cmp_ultisnips_mappings = require "cmp_nvim_ultisnips.mappings"
    cmp.setup {
        completion = { completeopt = "menu,menuone,noinsert" },
        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end,
        },
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
                cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                cmp_ultisnips_mappings.jump_backwards(fallback)
            end, { "i", "s"}),
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
            { name = "comdline" },
            { name = "treesitter" },
            { name = "ultisnips" },
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = lspkind.presets.default[vim_item.kind]
                return vim_item
            end,
        },
    }
    -- you need setup cmp first put this after cmp.setup()
    -- require("nvim-autopairs.completion.cmp").setup({
    --   map_cr = true, --  map <CR> on insert mode
    --   map_complete = true, -- it will auto insert `(` after select function or method item
    --   auto_select = true -- automatically select the first item
    -- })
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end
