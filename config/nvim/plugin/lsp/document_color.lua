---@class editor.DocumentColorConfig
---@field style "inline"|"background"|"foreground"
local config = {
    style = "inline",
    inline_symbol = "󰝤 ",
    debounce = 200,
    events = {
        "BufEnter",
        "TextChanged",
        "TextChangedI",
        "CursorMoved",
        "CursorMovedI",
    },
}

local function make_document_color_params(bufnr)
    return {
        textDocument = vim.lsp.util.make_text_document_params(bufnr),
    }
end

local ns = vim.api.nvim_create_namespace("document-color")

---@param red number
---@param green number
---@param blue number
---@param style editor.DocumentColorConfig["kind"]
local function set_hl_from(red, green, blue, style)
    local suffix = style == "background" and "Bg" or "Fg"
    local color = string.format("%02x%02x%02x", red, green, blue)
    local hl_name = "DocumentColor" .. suffix .. color
    local opts

    if style == "background" then
        -- https://stackoverflow.com/questions/3942878
        local luminance = red * 0.299 + green * 0.587 + blue * 0.114
        local fg = luminance > 186 and "#000000" or "#FFFFFF"
        opts = { fg = fg, bg = "#" .. color }
    else
        opts = { fg = "#" .. color }
    end

    if not vim.api.nvim_get_hl(0, { name = hl_name })[1] then
        vim.api.nvim_set_hl(0, hl_name, opts)
    end

    return hl_name
end

---@param bufnr number
---@param color lsp.ColorInformation
local function set_extmark(bufnr, color)
    local r = math.floor(color.color.red * 255)
    local g = math.floor(color.color.green * 255)
    local b = math.floor(color.color.blue * 255)
    local hl_group = set_hl_from(r, g, b, config.style)
    local start_row = color.range.start.line
    local start_col = color.range.start.character
    local opts = {}

    if config.style == "inline" then
        opts.virt_text = { { config.inline_symbol, hl_group } }
        opts.virt_text_pos = "inline"
    else
        opts.hl_group = hl_group
        opts.end_row = color.range["end"].line
        opts.end_col = color.range["end"].character
        opts.priority = 1000
    end

    vim.api.nvim_buf_set_extmark(bufnr, ns, start_row, start_col, opts)
end

---@generic F: fun()
---@param ms number
---@param fn F
---@return F
local function debounce(ms, fn)
    local timer = vim.uv.new_timer()
    local running = false
    return function(...)
        local args = { ... }
        if timer:is_active() then
            return
        end
        timer:start(ms, 0, vim.schedule_wrap(function() fn(unpack(args)) end))
    end
end

local function update_color(client, buf)
    local params = make_document_color_params(buf)
    client:request("textDocument/documentColor", params, function(err, result, context, config)
        if err then
            vim.notify("request documentColor filed")
            return
        end
        ---@type lsp.ColorInformation[]
        local colors = result
        -- vim.print(colors)
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

        for _, color in pairs(colors) do
            set_extmark(buf, color)
        end
    end)
end
update_color = debounce(config.debounce, update_color)

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buf = args.buf
        ---@cast client -nil
        if client:supports_method("textDocument/documentColor", buf) then
            vim.api.nvim_create_autocmd(config.events, {
                buffer = buf,
                callback = function() update_color(client, buf) end,
            })
        end
    end,
})

vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buf = args.buf
        ---@cast client -nil
        detach_update[client.id][buf] = true
    end,
})
