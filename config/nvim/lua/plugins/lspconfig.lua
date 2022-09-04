require('language_server.qmlls')
return function()
    local lspconfig = require('lspconfig')
    local lspkeymap_register = require('keymaps.lspbuffer')
    local mason_lspconfig = require('mason-lspconfig')
    -- reference https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

    local code_navigation = require('nvim-navic')

    local on_attach = function(client, bufnr)
        code_navigation.attach(client, bufnr)

        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        lspkeymap_register(bufnr)
    end
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    -- config that activates keymaps and enables snippet support
    local function make_config()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
        return {
            capabilities = capabilities,
            -- map buffer local keybindings when the language server attaches
            on_attach = on_attach,
        }
    end

    local servers = mason_lspconfig.get_installed_servers()
    table.insert(servers, 'qmlls')
    for _, server_name in ipairs(servers) do
        local server = lspconfig[server_name]
        local config = make_config()
        local success, hook = pcall(require, 'language.' .. server_name)
        if success then
            hook(config)
        end
        server.setup(config)
    end
end
