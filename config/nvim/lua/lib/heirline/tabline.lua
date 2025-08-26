local utils = require("heirline.utils")
local common = require("lib.heirline.common")
local Space = common.Space
local Align = common.Align
local FileNameView = common.FileNameView
local FileIcon = common.FileIcon
local FileFlags = common.FileFlags

---@param pos? Edgy.Pos
---@return boolean, number, number
local function edge_has_open(pos)
    local edgebar = require("edgy.config").layout[pos]
    return #edgebar.wins > 0, edgebar.bounds.width, edgebar.bounds.height
end


local TablineBufnr = {
    provider = function(self)
        return tostring(self.bufnr) .. ". "
    end,
    hl = "Comment",
}

local FileName = {
    provider = function(self)
        if self.filename == "" then
            return "[No Name]"
        end
        local filenames = vim.iter(vim.api.nvim_list_bufs()):filter(function(buf) return vim.bo[buf].buflisted end):map(vim.api.nvim_buf_get_name)
            :totable()
        local shortest_filenames = require("utils.path").shortest_suffixes(filenames)
        return shortest_filenames[self.filename]
    end,
    hl = function(self)
        local hl = {
            bold = self.is_active,
            italic = not self.is_active,
        }
        if not self.is_active then
            hl.italic = true
            hl.fg = utils.get_highlight("Comment").fg
        end
        return hl
    end,
}

-- Here the filename block finally comes together
local TablineFileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    end,
    hl = function(self)
        if self.is_active then
            return "tabsel_bg"
        else
            return "tabsel"
        end
    end,
    on_click = {
        callback = function(_, minwid, _, button)
            if (button == "m") then -- close on mouse middle click
                vim.schedule(function()
                    vim.api.nvim_buf_delete(minwid, { force = false })
                end)
            else
                vim.api.nvim_win_set_buf(0, minwid)
            end
        end,
        minwid = function(self)
            return self.bufnr
        end,
        name = "heirline_tabline_buffer_callback",
    },
    TablineBufnr,
    FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
    FileName,
    FileFlags,
}

-- a nice "x" button to close the buffer
local TablineCloseButton = {
    condition = function(self)
        return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
    end,
    { provider = " " },
    {
        provider = "",
        hl = { fg = "gray" },
        on_click = {
            callback = function(_, minwid)
                vim.schedule(function()
                    vim.api.nvim_buf_delete(minwid, { force = false })
                    vim.cmd.redrawtabline()
                end)
            end,
            minwid = function(self)
                return self.bufnr
            end,
            name = "heirline_tabline_close_buffer_callback",
        },
    },
}

-- The final touch!
local TablineBufferBlock = utils.surround({ "", "" }, function(self)
    if self.is_active then
        return "tabsel_bg"
    else
        return "tab_bg"
    end
end, { TablineFileNameBlock, TablineCloseButton })

-- and here we go
local BufferLine = utils.make_buflist(
    TablineBufferBlock,
    { provider = "", hl = { fg = "gray" } }, -- left truncation, optional (defaults to "<")
    { provider = "", hl = { fg = "gray" } } -- right trunctation, also optional (defaults to ...... yep, ">")
-- by the way, open a lot of buffers and try clicking them ;)
)
local TabLineLeftOffset = {
    condition = function()
        return not not package.loaded["edgy-group"]
    end,

    provider = function(self)
        local stl = require("edgy-group.stl")
        local left_line = stl.get_statusline("left")
        local content = table.concat(left_line)
        local icons = vim.iter(stl.cache.statuslines.left):map(function(item) return item.icon end):join("")


        local has_open, width = edge_has_open("left")
        if has_open then
            local pad = width - #icons
            return content .. string.rep(" ", pad)
        end
        return content
    end,

    hl = function(self)
        if vim.api.nvim_get_current_win() == self.winid then
            return "TablineSel"
        else
            return "Tabline"
        end
    end,
}

local Tabpage = {
    provider = function(self)
        return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
    end,
    hl = function(self)
        if not self.is_active then
            return "TabLine"
        else
            return "TabLineSel"
        end
    end,
}

local TabpageClose = {
    provider = "%999X  %X",
    hl = "TabLine",
}

local TabPages = {
    -- only show this component if there's 2 or more tabpages
    condition = function()
        return #vim.api.nvim_list_tabpages() >= 2
    end,
    { provider = "%=" },
    utils.make_tablist(Tabpage),
    TabpageClose,
}

local TabLineRightOffset = {
    condition = function()
        return not not package.loaded["edgy-group"]
    end,

    provider = function(self)
        local stl = require("edgy-group.stl")
        local left_line = stl.get_statusline("right")
        local content = table.concat(left_line)
        local icons = vim.iter(stl.cache.statuslines.right):map(function(item) return item.icon end):join("")


        local has_open, width = edge_has_open("right")
        if has_open then
            local pad = width - #icons
            return content .. string.rep(" ", pad)
        end
        return content
    end,

    hl = function(self)
        if vim.api.nvim_get_current_win() == self.winid then
            return "TablineSel"
        else
            return "Tabline"
        end
    end,
}

local TabLine = {
    TabLineLeftOffset,
    BufferLine,
    TabPages, Align,
    TabLineRightOffset,
}
return TabLine
