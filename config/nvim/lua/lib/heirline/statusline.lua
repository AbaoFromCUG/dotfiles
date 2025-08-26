local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local common = require("lib.heirline.common")
local Space = common.Space
local Align = common.Align
local FileNameView = common.FileNameView
local TerminalName = common.TerminalName
local FileIcon = common.FileIcon

local ViMode = {
    static = {
        mode_names = {
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
        },
        mode_colors = {
            n = "red",
            i = "green",
            v = "cyan",
            V = "cyan",
            ["\22"] = "cyan",
            c = "orange",
            s = "purple",
            S = "purple",
            ["\19"] = "purple",
            R = "orange",
            r = "orange",
            ["!"] = "red",
            t = "red",
        }
    },
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    provider = function(self)
        return " %2(" .. self.mode_names[self.mode] .. "%)"
    end,
    hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { fg = self.mode_colors[mode], bold = true, }
    end,
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    },
}

local FileName = {
    init = function(self)
        self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
        if self.lfilename == "" then self.lfilename = "[No Name]" end
    end,
    hl = { fg = utils.get_highlight("Directory").fg },

    flexible = 2,

    {
        provider = function(self)
            return self.lfilename
        end,
    },
    {
        provider = function(self)
            return vim.fn.pathshorten(self.lfilename, 2)
        end,
    },
}

FileName = utils.insert(FileNameView, FileName)

local Navic = {
    condition = function() return require("nvim-navic").is_available() end,
    provider = function()
        return require("nvim-navic").get_location({ highlight = true })
    end,
    update = "CursorMoved"
}

local Git = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        local added = self.status_dict.added or 0
        local removed = self.status_dict.removed or 0
        local changed = self.status_dict.changed or 0
        self.has_changes = added ~= 0 or removed ~= 0 or changed ~= 0
    end,

    hl = { fg = "orange" },

    -- git branch name
    {
        provider = function(self)
            return " " .. self.status_dict.head
        end,
        hl = { bold = true }
    },
    -- You could handle delimiters, icons and counts similar to Diagnostics
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = "("
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
        end,
        hl = { fg = "git_add" },
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
        end,
        hl = { fg = "git_del" },
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
        end,
        hl = { fg = "git_change" },
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = ")",
    },
}

local Diagnostics = {
    condition = conditions.has_diagnostics,

    -- If you defined custom LSP diagnostics with vim.fn.sign_define(), use this instead
    -- Note defining custom LSP diagnostic this way its deprecated, though
    static = {
        error_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR],
        warn_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN],
        info_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO],
        hint_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT],
    },

    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,

    update = { "DiagnosticChanged", "BufEnter" },

    {
        provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = { fg = "diag_error" },
    },
    {
        provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = { fg = "diag_warn" },
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. " ")
        end,
        hl = { fg = "diag_info" },
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = "diag_hint" },
    },
}

local BottomEdgyGroup = {
    condition = function()
        return not not package.loaded["edgy-group"]
    end,
    provider = function()
        local stl = require("edgy-group.stl")
        local bottom_line = stl.get_statusline("bottom")
        return table.concat(bottom_line)
    end
}


local FileEncoding = {
    provider = function()
        local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
        return enc
    end
}

local FileFormat = {
    provider = function()
        local symbols = {
            unix = "", -- e712
            dos = "", -- e70f
            mac = "", -- e711
        }
        local fmt = vim.bo.fileformat
        return symbols[fmt]
    end
}
local FileStatus = utils.insert(FileNameView,
    FileEncoding,
    Space,
    FileFormat,
    Space,
    FileIcon,
    Space
)

local FileType = {
    provider = function()
        return string.upper(vim.bo.filetype)
    end,
    hl = { fg = utils.get_highlight("Type").fg, bold = true },
}


local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%7(%l/%3L%):%2c %P",
}



local DefaultStatusline = {
    ViMode, Space, FileName, Space, Navic, Space, Git, Space, Diagnostics,
    Align,
    BottomEdgyGroup,
    Align,
    FileStatus,
    Space, Ruler,
}

local SpecialStatusline = {
    condition = function()
        return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive" },
        })
    end,

    FileType,
    Space,
    Align,
    BottomEdgyGroup,
    Align,
}
local TerminalStatusline = {

    condition = function()
        return conditions.buffer_matches({ buftype = { "terminal" } })
    end,

    hl = { bg = "dark_red" },

    -- Quickly add a condition to the ViMode to only show it when buffer is active!
    { condition = conditions.is_active, ViMode, Space },
    FileType,
    Space,
    TerminalName,
    Align,
    BottomEdgyGroup,
    Align,
}
local InactiveStatusline = {
    condition = conditions.is_not_active,
    FileType,
    Space,
    FileName,
    Align,
}

local StatusLines = {

    hl = function()
        if conditions.is_active() then
            return "StatusLine"
        else
            return "StatusLineNC"
        end
    end,

    -- the first statusline with no condition, or which condition returns true is used.
    -- think of it as a switch case with breaks to stop fallthrough.
    fallthrough = false,

    SpecialStatusline,
    TerminalStatusline,
    InactiveStatusline,
    DefaultStatusline,
}
return StatusLines
