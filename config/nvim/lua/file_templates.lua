local M = {}

local Path = require 'plenary.path'
local a = require 'plenary.async'
local fn = vim.fn
local uv = vim.loop

local function read_file(file)
    local _, fd = a.uv.fs_open(file, 'r', 438)
    local _, stat = a.uv.fs_fstat(fd)
    local content = uv.fs_read(fd, stat.size, 0)
    a.uv.fs_close(fd)
    return content
end

local function write_file(path, content)
    path = Path:new(path)
    path:parent():mkdir { parents = true, exist_ok = true }
    local _, fd = a.uv.fs_open(path:absolute(), 'w', 438)
    local err, _ = a.uv.fs_write(fd, content)
    assert(not err, err)
end

local function load_template_config(config_path)
    return vim.json.decode(read_file(config_path))
end

local builtin_config = {
    user_name = fn.expand '$USERNAME'
}

M.template_configs = {}

local async_select = a.wrap(function(items, opts, callback)
    vim.schedule_wrap(function()
        vim.ui.select(items, opts, callback)
    end)()
end, 3)

local async_input = a.wrap(function(opts, on_confirm)
    vim.schedule_wrap(function()
        vim.ui.input(opts, on_confirm)
    end)()
end, 2)

local function choice_options(config)
    local result = {}
    for key, value in pairs(builtin_config) do
        result[key] = value
    end
    if config.options then
        for _, option in ipairs(config.options) do
            if option.options then
                local selected = async_select(option.options, { prompt = option.name .. ': ' })
                result[option.id] = selected or option.default_value
            else
                local inputed = async_input { prompt = option.name .. ': ', default = option.default_value }
                result[option.id] = inputed or option.default_value
            end
        end
    end
    return result
end

local function refresh_templates()
    local config_root = Path:new(fn.stdpath 'config')
    local templates_root = config_root:joinpath('share', 'templates')
    local template_list = fn.split(fn.globpath(templates_root:absolute() .. '/*/', 'template.json'), '\n')
    for _, config_path in pairs(template_list) do
        local config = load_template_config(config_path)
        table.insert(M.template_configs, { path = config_path, config = config })
    end
end

local function str_replace(text, old, new)
    old = old:gsub('[%^%$%(%)%%%.%[%]%*%+%-%?]', '%%%1')
    return text:gsub(old, new)
end

local function expand_config_variables(options, str)
    local bad_local = '';
    for key, value in pairs(options) do
        bad_local = bad_local .. 'local ' .. key .. "='" .. value .. "';"
    end
    for matched in str:gmatch '%%{.-}' do
        local lua_expr = matched:match '%%{lua (.-)}'
        if lua_expr then
            local result = loadstring(bad_local .. 'return ' .. lua_expr)()
            str = str_replace(str, matched, result)
        else
            local key = matched:match '%%{(.-)}'
            if options[key] then
                str = str_replace(str, matched, options[key])
            end
        end
    end

    return str
end

--
function M.create(_base_path)
    local base_path = Path:new(_base_path)
    a.run(function()
        if #M.template_configs <= 0 then
            refresh_templates()
        end
        local item = async_select(M.template_configs, {
            prompt = 'Select templates',
            format_item = function(item)
                return item.config.name
            end
        })
        if not item then
            return
        end
        local options = choice_options(item.config)
        local config_path = Path:new(item.path)
        local write_tasks = {}
        for _, output in ipairs(item.config.output_files) do
            local source_path = config_path:parent():joinpath(output.from):absolute()
            local file_content = read_file(source_path)
            local expand_content = expand_config_variables(options, file_content)

            local target_filename = expand_config_variables(options, output.to)
            local target_path = base_path:joinpath(target_filename)
            if (target_path:is_file()) then
                vim.notify("can't create, the file{" .. target_path:absolute() .. '} already exists')
                return
            end
            write_tasks[target_path] = expand_content
        end
        for path, content in pairs(write_tasks) do
            write_file(path, content)
        end
    end, function()

    end)
end

return M
