return function()
    local lspconfig = require("lspconfig")
    local lspkeymap_register = require("keymap.lspbuf")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

        -- Mappings.
        lspkeymap_register(bufnr)
    end
    -- config that activates keymaps and enables snippet support
    local function make_config()
        local capabilities = cmp_nvim_lsp.default_capabilities()
        return {
            capabilities = capabilities,
            -- map buffer local keybindings when the language server attaches
            on_attach = on_attach,
        }
    end
    require("mason-lspconfig").setup_handlers({
        function(server_name)
            local server = lspconfig[server_name]
            local config = make_config()
            local module_name = "plugins.lsp.server." .. server_name
            local success, hook = pcall(require, module_name)
            if success then
                hook(config)
            end
            server.setup(config)
        end,
        -- don't setup volar
        ["volar"] = function() end,
        ["tsserver"] = function() end,
    })
end
