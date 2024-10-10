local function smart_format()
    local eslint = vim.lsp.get_clients({ name = "eslint" })[1]
    if eslint then
        vim.lsp.buf.format({
            filter = function(client)
                return client.name ~= "ts_ls" and client.name ~= "typescript-tools" and client.name ~= "volar"
            end,
        })
    else
        vim.lsp.buf.format()
    end
end

return function()
    local lspconfig = require("lspconfig")
    -- local cmp_nvim_lsp = require("cmp_nvim_lsp")

    require("vim.lsp.log").set_format_func(vim.inspect)

    local function setup_server(server_name)
        local server = lspconfig[server_name]

        local config = {
            -- capabilities = cmp_nvim_lsp.default_capabilities(),
            capabilities = {},
        }
        if server_name == "jsonls" then
            config.settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            }
        end

        local module_name = "plugins.lsp.server." .. server_name
        local success, hook = pcall(require, module_name)
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
        ["ts_ls"] = function() end,
    })

    setup_server("qmlls")
    setup_server("neocmake")

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local bufnr = args.buf

            require("which-key").add({
                { "<space>gd", vim.lsp.buf.definition, desc = "goto definition" },
                { "<space>gD", vim.lsp.buf.declaration, desc = "goto declaration" },
                { "<space>gi", vim.lsp.buf.implementation, desc = "goto implementation" },
                { "<space>gr", vim.lsp.buf.references, desc = "list reference" },
                { "<space>rn", vim.lsp.buf.rename, desc = "rename" },
                { "<space>ca", vim.lsp.buf.code_action, desc = "code action", mode = { "n", "v" } },

                { "<space>e", vim.diagnostic.open_float, desc = "open diagnostic" },
                { "<space>f", smart_format, desc = "format" },
                { "<space>q", vim.diagnostic.setloclist, desc = "diagnostic list" },

                { "<C-k>", vim.lsp.buf.signature_help, desc = "open signature help" },
            }, { buffer = bufnr })
        end,
    })
end
