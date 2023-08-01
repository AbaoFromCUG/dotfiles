local M = {}

local fn = vim.fn
local Path = require("plenary.path")

M.current_launch_conf = nil

local function format_config(item)
    if item then
        return string.format("%s (%s)", item.name, item.type)
    end
    return ""
end

function M.refresh_launcher()
    local dap = require("dap")
    local fake_vscode = require("dap.ext.vscode")
    -- clear raw configuration
    dap.configurations = {}
    local launch_filepath = Path:new(fn.getcwd()):joinpath(".vscode/launch.json"):absolute()
    fake_vscode.load_launchjs(launch_filepath)
    -- just check name to ensure unique
    local named_config = {}
    for _, subconfigs in pairs(dap.configurations) do
        for _, item in ipairs(subconfigs) do
            if named_config[item.name] then
                vim.notify("name is not unique", vim.log.levels.ERROR)
                return
            end
            named_config[item.name] = item
        end
    end
end

function M.select_launch_conf()
    local dap = require("dap")
    local extend_configurations = {}
    for _, subconfigs in pairs(dap.configurations) do
        for _, item in ipairs(subconfigs) do
            table.insert(extend_configurations, item)
        end
    end
    if vim.tbl_isempty(extend_configurations) then
        vim.notify("No configuration, please check launch.json" .. vim.inspect(extend_configurations))
        return
    end
    vim.ui.select(extend_configurations, {
        format_item = format_config,
    }, function(item)
        if item then
            M.current_launch_conf = item
        end
    end)
end

function M.select_by_name(name)
    local dap = require("dap")
    for _, subconfigs in pairs(dap.configurations) do
        for _, item in ipairs(subconfigs) do
            if item.name == name then
                M.current_launch_conf = item
                return
            end
        end
    end
    vim.notify(string.format("no name (%s) launch", name))
end

function M.run()
    local current_file = vim.fn.expand("%:p")
    local dap = require("dap")

    if current_file and current_file:sub(-#"_spec.lua") == "_spec.lua" then
        require("plenary.test_harness").test_directory(current_file)
    elseif dap.session() then
        dap.continue()
    elseif M.current_launch_conf then
        dap.run(M.current_launch_conf)
    else
        vim.notify("not selected launch, please edit launch.json or refresh", vim.log.levels.WARN)
    end
end

function M.terminate()
    local dap = require("dap")
    dap.terminate()
end

function M.build()
    local overseer = require("overseer")
    local files = require("overseer.files")
    overseer.run_template()
end

---Current display string for statusline, return `name (type)` or `(Empty)`
function M.current_display_name()
    return format_config(M.current_launch_conf)
end

function M.is_available()
    local dap = require("dap")
    return not vim.tbl_isempty(dap.configurations)
end

return M
