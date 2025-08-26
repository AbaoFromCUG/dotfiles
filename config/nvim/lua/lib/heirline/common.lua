local utils = require("heirline.utils")

return {

    Align = { provider = "%=" },
    Space = { provider = " " },
    FileNameView = {
        -- let's first set up some attributes needed by this component and its children
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
        end,
    },

    FileIcon = {
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
    },

    FileType = {
        provider = function()
            return string.upper(vim.bo.filetype)
        end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
    },

    FileFlags = {
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
    },

    TerminalName = {
        -- we could add a condition to check that buftype == 'terminal'
        -- or we could do that later (see #conditional-statuslines below)
        provider = function()
            local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
            return " " .. tname
        end,
        hl = { fg = "blue", bold = true },
    },
}
