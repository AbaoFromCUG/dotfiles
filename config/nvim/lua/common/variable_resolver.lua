local utils = require("common.utils")
local commands = require("common.commands")

local M = {}

local variable_map = {
    userHome = function()
        return vim.env.HOME
    end,
    workspaceFolder = function()
        return vim.lsp.buf.list_workspace_folders()[0]
    end,
    workspaceFolderBasename = function()
        return vim.fn.fnamemodify(vim.lsp.buf.list_workspace_folders()[0], ":t")
    end,
    file = function()
        return vim.fn.expand("%:p")
    end,
    fileWorkspaceFolder = function()
        -- TODO
    end,
    relativeFile = function()
        return vim.fn.expand("%:.")
    end,
    relativeFileDirName = function()
        return vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
    end,
    fileBasename = function()
        return vim.fn.expand("%:t")
    end,
    fileBasenameNoExtension = function()
        return vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
    end,
    fileDirname = function()
        return vim.fn.expand("%:p:h")
    end,
    fileExtname = function()
        return vim.fn.expand("%:e")
    end,
    cwd = vim.fn.getcwd,
    lineNumber = vim.api.nvim_get_current_line,
    selectedText = function()
        ---TODO
    end,
    execPath = function()
        ---TODO
    end,
    defaultBuildTask = function()
        ---TODO
    end,
    pathSeparator = function()
        if vim.fn.has("win32") then
            return "\\"
        end
        return "/"
    end,
    env = function(name)
        return vim.env[name]
    end,
    option = vim.api.nvim_get_option,
    variable = vim.api.nvim_get_var,
}

---@param variable string
function M.evaluateSingleVariable(variable)
    local parts = vim.split(variable, ":")
    local argument = nil
    if #parts > 1 then
        variable = parts[0]
        argument = parts[1]
    end

    local handle = variable_map[variable] or commands.get_command(variable)
    if type(handle) == "function" then
        return handle(argument)
    end
    return handle
end

return M
