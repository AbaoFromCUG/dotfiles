---@param pos? Edgy.Pos
---@return boolean, number, number
local function edge_has_open(pos)
    local edgebar = require("edgy.config").layout[pos]
    return #edgebar.wins > 0, edgebar.bounds.width, edgebar.bounds.height
end



local Align = { provider = "%=" }
local Space = { provider = " " }

local FileNameBlock = {
    -- let's first set up some attributes needed by this component and its children
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
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

local FileIcon = {
    init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
        return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end
}

local FileFlags = {
    {
        condition = function(self)
            return vim.bo[self.bufnr or 0].modified
        end,
        provider = "[+]",
        hl = { fg = "green" },
    },
    {
        condition = function(self)
            return not vim.bo[self.bufnr or 0].modifiable or vim.bo[self.bufnr or 0].readonly
        end,

        provider = function(self)
            if vim.bo[self.bufnr or 0].buftype == "terminal" then
                return " "
            else
                return " "
            end
        end,
        hl = { fg = "orange" },
    },
}

local TerminalName = {
    -- we could add a condition to check that buftype == 'terminal'
    -- or we could do that later (see #conditional-statuslines below)
    provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
        return " " .. tname
    end,
    hl = { fg = "blue", bold = true },
}



local function statusline()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

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

    FileName = utils.insert(FileNameBlock, FileName)

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
        provider = function()
            local stl = require("edgy-group.stl")
            local bottom_line = stl.get_statusline("bottom")
            return table.concat(bottom_line)
        end
    }

    local FileStatus = utils.insert(FileNameBlock,
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
end


local function tabline()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")
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
        condition = function(self)
            return true
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
        condition = function(self)
            return true
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

    local TabLine = { TabLineLeftOffset, BufferLine, TabPages,Align, TabLineRightOffset }
    return TabLine
end


local function winbar()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")
    local FileType = {
        provider = function()
            return string.upper(vim.bo.filetype)
        end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
    }
    -- We can now define some children separately and add them later


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
            if filename == "" then return "[No Name]" end
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

    local WinBarFileNameBlock = utils.insert(FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
        FileFlags,
        { provider = "%<" }                      -- this means that the statusline is cut here when there's not enough space
    )

    local EmptyWinbar = {
        condition = function()

        end,

    }

    local WinBars = {
        fallthrough = false,
        -- A special winbar for terminals
        {
            condition = function()
                return conditions.buffer_matches({ buftype = { "terminal" } })
            end,
            utils.surround({ "", "" }, "dark_red", {
                FileType,
                Space,
                TerminalName,
            }),
        },
        -- An inactive winbar for regular files
        {
            condition = function()
                return not conditions.is_active()
            end,
            utils.surround({ "", "" }, "bright_bg", { hl = { fg = "gray", force = true }, WinBarFileNameBlock }),
        },
        -- A winbar for regular files
        utils.surround({ "", "" }, "bright_bg", WinBarFileNameBlock),
    }
    return WinBars
end

return {
    {
        "rebelot/heirline.nvim",
        event = "VeryLazy",
        keys = {
            { "<S-l>", "<cmd>bnext<cr>",     desc = "focus right tab" },
            { "<S-h>", "<cmd>bprevious<cr>", desc = "focus left tab" },
        },

        opts = function()
            local conditions = require("heirline.conditions")
            local utils = require("heirline.utils")
            local colors = {

                tabsel_bg = utils.get_highlight("Normal").bg,
                tab_bg = utils.get_highlight("TabLineFill").bg,

                bright_bg = utils.get_highlight("Folded").bg,
                bright_fg = utils.get_highlight("Folded").fg,
                red = utils.get_highlight("DiagnosticError").fg,
                dark_red = utils.get_highlight("DiffDelete").bg,
                green = utils.get_highlight("String").fg,
                blue = utils.get_highlight("Function").fg,
                gray = utils.get_highlight("NonText").fg,
                orange = utils.get_highlight("Constant").fg,
                purple = utils.get_highlight("Statement").fg,
                cyan = utils.get_highlight("Special").fg,
                diag_warn = utils.get_highlight("DiagnosticWarn").fg,
                diag_error = utils.get_highlight("DiagnosticError").fg,
                diag_hint = utils.get_highlight("DiagnosticHint").fg,
                diag_info = utils.get_highlight("DiagnosticInfo").fg,
                git_del = utils.get_highlight("NeogitDiffDelete").fg,
                git_add = utils.get_highlight("diffAdded").fg,
                git_change = utils.get_highlight("diffChanged").fg,
            }
            require("heirline").load_colors(colors)


            vim.o.showtabline = 2
            return {
                statusline = statusline(),
                tabline = tabline(),
                winbar = winbar(),
                opts = {
                    disable_winbar_cb = function(args)
                        if vim.api.nvim_win_get_config(0).relative ~= "" then
                            return true
                        end
                        return conditions.buffer_matches({
                            buftype = { "nofile", "prompt", "help", "quickfix" },
                            filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
                        }, args.buf)
                    end,
                }
            }
        end,

    },

}
