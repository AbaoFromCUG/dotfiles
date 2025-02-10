---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()

vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                if value.title == "formatting" then
                    return
                end
                p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "",
                        value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v) return table.insert(msg, v.msg) or not v.done end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif) notif.icon = #progress[client.id] == 0 and " " or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] end,
        })
    end,
})

local function smart_format()
    local eslint = vim.lsp.get_clients({ name = "eslint" })[1]
    if eslint then
        vim.lsp.buf.format({
            filter = function(client) return not vim.tbl_contains({ "ts_ls", "typescript-tools", "vtsls", "volar", "jsonls" }, client.name) end,
        })
    else
        vim.lsp.buf.format()
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buf = args.buf
        ---@cast client -nil
        local function map(lhs, rhs, desc, mode) vim.keymap.set(mode or "n", lhs, rhs, { desc = desc, buffer = buf }) end
        if client:supports_method("textDocument/definition", buf) then
            map("gd", vim.lsp.buf.definition, "goto definition")
        end
        if client:supports_method("textDocument/declaration", buf) then
            map("gD", vim.lsp.buf.declaration, "goto declaration")
        end
        if client:supports_method("textDocument/diagnostic", buf) then
            map("<space>e", vim.diagnostic.open_float, "open diagnostic")
        end
        if client:supports_method("textDocument/formatting", buf) then
            map("<space>f", smart_format, "format")
        end
    end,
})

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
        },
    },
})
