return function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    require("vim.lsp.log").set_format_func(vim.inspect)

    require("mason-lspconfig").setup_handlers({
        function(server_name)
            local server = lspconfig[server_name]
            local module_name = "plugins.lsp.server." .. server_name
            local success, hook = pcall(require, module_name)

            local config = {
                capabilities = cmp_nvim_lsp.default_capabilities(),
            }
            if success then
                hook(config)
            end
            server.setup(config)
        end,
        ["volar"] = function() end,
        ["texlab"] = function() end,
        ["lua_ls"] = function() end,
    })
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "open diagnostic" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic" })
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "diagnostic list" })

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            ---@cast client -nil
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

            if client.supports_method("textDocument/declaration") then
                vim.keymap.set("n", "<space>gd", vim.lsp.buf.declaration, { buffer = buffer, desc = "goto declaration" })
            elseif client.supports_method("textDocument/type_definition") then
                vim.keymap.set("n", "<space>gd", vim.lsp.buf.type_definition, { buffer = buffer, desc = "goto definition" })
            else
                vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, { buffer = buffer, desc = "goto definition" })
            end
            if client.supports_method("textDocument/implementation") then
                vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, { buffer = buffer, desc = "goto implementation" })
            elseif client.supports_method("textDocument/implementation") then
                vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, { buffer = buffer, desc = "goto implementation" })
            end

            if client.supports_method("textDocument/implementation") then
                vim.keymap.set("n", "g<C-I>", vim.lsp.buf.implementation, { buffer = args.buf })
            end

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "display hover info" })
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = buffer, desc = "open signature help" })

            vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = buffer, desc = "rename" })
            vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code action" })
            vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, { buffer = buffer, desc = "list reference" })
        end,
    })
end
