local function smart_format()
    local eslint = vim.lsp.get_clients({ name = "eslint" })[1]
    if eslint then
        vim.lsp.buf.format({
            filter = function(client)
                return client.name ~= "tsserver" and client.name ~= "typescript-tools" and client.name ~= "volar"
            end,
        })
    else
        vim.lsp.buf.format()
    end
end

return function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    require("vim.lsp.log").set_format_func(vim.inspect)

    local function setup_server(server_name)
        local server = lspconfig[server_name]
        local module_name = "plugins.lsp.server." .. server_name
        local success, hook = pcall(require, module_name)

        local config = {
            capabilities = cmp_nvim_lsp.default_capabilities(),
        }
        if success then
            hook(config)
        elseif #vim.split(hook, "\n") < 3 then
            error(hook)
        end
        server.setup(config)
    end

    require("mason-lspconfig").setup_handlers({
        setup_server,
        -- ["volar"] = function() end,
        -- ["texlab"] = function() end,
        ["lua_ls"] = function() end,
        ["tsserver"] = function() end,
    })

    setup_server("qmlls")
    setup_server("neocmake")

    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "open diagnostic" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic" })
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "diagnostic list" })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
            end

            map("n", "<space>gd", vim.lsp.buf.definition, "goto definition")
            map("n", "<space>gi", vim.lsp.buf.implementation, "goto implementation")
            map("n", "K", vim.lsp.buf.hover, "display hover info")
            map("n", "<C-k>", vim.lsp.buf.signature_help, "open signature help")
            map("n", "<space>rn", vim.lsp.buf.rename, "rename")
            map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, "code action")
            map("n", "<space>gr", vim.lsp.buf.references, "list reference")

            map("n", "<space>f", smart_format, "format")
        end,
    })
end
