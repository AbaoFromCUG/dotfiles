local M = {}

local Path = require("pathlib")
local nio = require("nio")

local function write_file(path, content)
    path = Path(path)
    path:parent():mkdir(Path.permission(""), true)
    local _, fd = nio.uv.fs_open(path:absolute(), "w", 438)
    local err, _ = nio.uv.fs_write(fd, content)
    assert(not err, err)
end

---local json config
---@param config_path string
---@return unknown
local function load_template_config(config_path)
    local file = nio.file.open(config_path, "r")
    local content = file.read()
    return vim.json.decode(content)
end

local builtin_config = {
    user_name = nio.fn.expand("$USERNAME"),
}

M.template_configs = {}

local function choice_options(config)
    local result = {}
    for key, value in pairs(builtin_config) do
        result[key] = value
    end

    if config.options then
        for _, option in ipairs(config.options) do
            if option.options then
                local selected = nio.ui.select(option.options, { prompt = option.name .. ": " })
                result[option.id] = selected or option.default_value
            else
                local inputed = nio.ui.input({ prompt = option.name .. ": ", default = option.default_value })
                result[option.id] = inputed or option.default_value
            end
        end
    end
    return result
end

local function refresh_templates()
    local templ_root = Path.stdpath("config", "share", "templates")
    -- templ_root:glob
    for config_path in templ_root:glob("./*/template.json") do
        local config = load_template_config(tostring(config_path))
        table.insert(M.template_configs, { path = config_path, config = config })
    end
end
local function str_replace(text, old, new)
    old = old:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
    return text:gsub(old, new)
end

local function expand_config_variables(options, str)
    local bad_local = ""
    for key, value in pairs(options) do
        bad_local = bad_local .. "local " .. key .. "='" .. value .. "';"
    end
    for matched in str:gmatch("%%{.-}") do
        local lua_expr = matched:match("%%{lua (.-)}")
        if lua_expr then
            local result = loadstring(bad_local .. "return " .. lua_expr)()
            str = str_replace(str, matched, result)
        else
            local key = matched:match("%%{(.-)}")
            if options[key] then
                str = str_replace(str, matched, options[key])
            end
        end
    end

    return str
end

--
function M.create(_base_path)
    nio.run(function()
        local base_path = Path(_base_path)
        if #M.template_configs <= 0 then
            refresh_templates()
        end

        nio.scheduler()
        local item = nio.ui.select(M.template_configs, {
            prompt = "Select templates",
            format_item = function(item)
                return item.config.name
            end,
        })
        print("select:", item)
        if not item then
            return
        end
        local options = choice_options(item.config)
        local config_path = Path(item.path)
        local write_tasks = {}
        for _, output in ipairs(item.config.output_files) do
            local source_path = config_path:parent():child(output.from):absolute()
            local file_content = read_file(source_path)
            local expand_content = expand_config_variables(options, file_content)

            local target_filename = expand_config_variables(options, output.to)
            local target_path = base_path:joinpath(target_filename)
            if target_path:is_file() then
                vim.notify("can't create, the file{" .. target_path:absolute() .. "} already exists")
                return
            end
            write_tasks[target_path] = expand_content
        end
        for path, content in pairs(write_tasks) do
            write_file(path, content)
        end
    end, function(v, e)
        print(vim.inspect(v), e)
        assert(v, e)
    end)
end

return M
