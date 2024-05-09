return function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

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
        -- don't setup volar
        ["volar"] = function() end,
        ["tsserver"] = function() end,
    })
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local buffer = ev.buf
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buffer, desc = "jump to declaration" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "jump to dfinition" })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "display hover info" })
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buffer, desc = "list implementation" })
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = buffer, desc = "open signature help" })
            vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { buffer = buffer, desc = "add workspace" })
            vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { buffer = buffer, desc = "jump to type definition" })
            vim.keymap.set("n", "<space>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, { buffer = buffer, desc = "list workspaces" })
            vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, { buffer = buffer, desc = "jump to type definition" })
            vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = buffer, desc = "rename" })
            vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code action" })
            vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buffer, desc = "list reference" })
            vim.keymap.set("n", "<space>f", function()
                vim.lsp.buf.format({ async = true })
            end, { buffer = buffer, desc = "jump to type definition" })
        end,
    })
end
