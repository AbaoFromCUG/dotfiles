local M = {}
function M.explorer_find_file(picker, item)
    if not item then
        return
    end
    ---@type string[]
    local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected())
    paths = #paths > 0 and paths or { vim.fs.dirname(item.file) }
    Snacks.picker.files({ ignored = true, hidden = true, dirs = paths })
end

function M.explorer_grep(picker, item)
    if not item then
        return
    end
    ---@type string[]
    local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected())
    paths = #paths > 0 and paths or { vim.fs.dirname(item.file) }
    Snacks.picker.grep({ ignored = true, hidden = true, dirs = paths })
end

function M.explorer_search_and_replace(picker, item)
    if not item then
        return
    end
    ---@type string[]
    local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected())
    paths = #paths > 0 and paths or { vim.fs.dirname(item.file) }
    require("spectre").toggle({ search_paths = paths })
end

function M.explorer_context_menu(picker, item)
    vim.cmd.exec('"normal! \\<RightMouse>"')

    if not item then
        return
    end
    ---@type string[]
    local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected())

    local items = {
        {
            name = "  New file/folder",
            cmd = function() api.fs.create(node()) end,
            rtxt = "a",
        },

        { name = "separator" },

        {
            name = "  Open in window",
            cmd = function() api.node.open.edit(node()) end,
            rtxt = "o",
        },

        {
            name = "  Open in vertical split",
            cmd = function() api.node.open.vertical(node()) end,
            rtxt = "v",
        },

        {
            name = "  Open in horizontal split",
            cmd = function() api.node.open.horizontal(node()) end,
            rtxt = "s",
        },

        {
            name = "󰓪  Open in new tab",
            cmd = function() api.node.open.tab(node()) end,
            rtxt = "O",
        },

        { name = "separator" },

        {
            name = "  Cut",
            cmd = function() api.fs.cut(node()) end,
            rtxt = "x",
        },

        {
            name = "  Paste",
            cmd = function() api.fs.paste(node()) end,
            rtxt = "p",
        },

        {
            name = "  Copy",
            cmd = function() api.fs.copy.node(node()) end,
            rtxt = "c",
        },

        {
            name = "󰴠  Copy absolute path",
            cmd = function() api.fs.copy.absolute_path(node()) end,
            rtxt = "gy",
        },

        {
            name = "  Copy relative path",
            cmd = function() api.fs.copy.relative_path(node()) end,
            rtxt = "Y",
        },

        { name = "separator" },

        {
            name = "  Open in terminal",
            hl = "ExBlue",
            cmd = function()
                local path = node().absolute_path
                local node_type = vim.uv.fs_stat(path).type
                local dir = node_type == "directory" and path or vim.fn.fnamemodify(path, ":h")

                vim.cmd("enew")
                vim.fn.termopen({ vim.o.shell, "-c", "cd " .. dir .. " ; " .. vim.o.shell })
            end,
        },

        { name = "separator" },

        {
            name = "  Rename",
            cmd = function() api.fs.rename(node()) end,
            rtxt = "r",
        },

        {
            name = "  Trash",
            cmd = function() api.fs.trash(node()) end,
            rtxt = "D",
        },

        {
            name = "  Delete",
            hl = "ExRed",
            cmd = function() api.fs.remove(node()) end,
            rtxt = "d",
        },
    }

    require("menu").open(items, { mouse = true })
end

return M
