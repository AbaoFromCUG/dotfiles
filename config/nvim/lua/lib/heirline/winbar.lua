local common = require("lib.heirline.common")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local Space = common.Space
local Align = common.Align
local FileNameView = common.FileNameView
local FileIcon = common.FileIcon
local FileType = common.FileType
local FileFlags = common.FileFlags
local TerminalName = common.TerminalName

local FileNameModifer = {
    hl = function()
        if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = "cyan", bold = true, force = true }
        end
    end,
}

local FileName = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
            return "[No Name]"
        end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
    hl = { fg = utils.get_highlight("Directory").fg },
}

local WinBarFileNameBlock = utils.insert(
    FileNameView,
    FileIcon,
    utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
    FileFlags,
    { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)

local WinBars = {
    fallthrough = false,
    -- A special winbar for terminals
    {
        condition = function() return conditions.buffer_matches({ buftype = { "terminal" } }) end,
        utils.surround({ "", "" }, "dark_red", {
            FileType,
            Space,
            TerminalName,
        }),
    },
    -- An inactive winbar for regular files
    {
        condition = function() return not conditions.is_active() end,
        utils.surround({ "", "" }, "bright_bg", { hl = { fg = "gray", force = true }, WinBarFileNameBlock }),
    },
    -- A winbar for regular files
    utils.surround({ "", "" }, "bright_bg", WinBarFileNameBlock),
}
return WinBars
