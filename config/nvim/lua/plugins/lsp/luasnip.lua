---@class snacks.picker.luasnip.Config
---@field ft? string|string[] file type[s]



---@type snacks.picker.Config
return {
    source = "luasnip",
    ---@param opts snacks.picker.luasnip.Config
    finder = function(opts, ctx)
        local ft = opts and opts.ft or vim.bo.filetype
        local fts = vim.islist(ft) and ft or { ft }
        if not vim.list_contains(fts, "all") then
            table.insert(fts, "all")
        end
        local luasnip = require("luasnip")

        -- local snippets = require("luasnip").available(function(snip) return snip end)
        ---@type snacks.picker.Item[]
        local items = {}
        vim.iter(fts):each(function(filetype)
            vim.iter(luasnip.get_snippets(filetype)):each(function(snip, idx)
                ---@cast snip LuaSnip.Snippet
                local item = {
                    text = snip.trigger .. table.concat(snip.description, "\n"),
                    snip = snip,
                    snip_ft = filetype
                }
                table.insert(items, item)
            end)
        end)
        return items
    end,
    format = function(item, picker)
        local ret = {} ---@type snacks.picker.Highlight[]

        ---@type LuaSnip.Snippet
        local snip = item.snip
        local ft = item.snip_ft

        local icon, hl = Snacks.util.icon(ft, "filetype")
        icon = Snacks.picker.util.align(icon, picker.opts.formatters.file.icon_width or 2)
        ret[#ret + 1] = { icon, hl, virtual = true }
        local trigger = Snacks.picker.util.align(snip.trigger, 10)
        Snacks.picker.highlight.format(item, trigger, ret, { lang = "text" })
        -- Snacks.picker.highlight.format(item, snip:get_docstring(), ret, { lang = "text" })
        Snacks.picker.highlight.format(item, table.concat(snip.description, "\n"), ret, { lang = "text" })
        return ret
    end,
    ---@param ctx snacks.picker.preview.ctx
    preview = function(ctx)
        ---@type LuaSnip.Snippet
        local snip = ctx.item.snip
        ---@type string
        local ft = ctx.item.snip_ft
        ctx.preview:reset()
        local lines = snip:get_static_text()
        ctx.preview:set_lines(lines)
        if ft then
            ctx.preview:highlight({ ft = ft })
        end
    end,
}
