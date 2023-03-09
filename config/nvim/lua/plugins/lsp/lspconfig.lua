return function()
    local lspconfig = require 'lspconfig'
    local lspkeymap_register = require 'keymap.lspbuffer'
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'
    local code_navigation = require 'nvim-navic'
    local mason_lspconfig = require 'mason-lspconfig'

    local on_attach = function(client, bufnr)
        code_navigation.attach(client, bufnr)

        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
    local servers = mason_lspconfig.get_installed_servers()
    table.insert(servers, 'qmlls')
    for i, server_name in pairs(servers) do
        local server = lspconfig[server_name]
        local config = make_config()
        local module_name = 'plugins.lsp.lang_spec.' .. server_name
        local success, hook = pcall(require, module_name)
        if success then
            hook(config)
        end
        server.setup(config)
    end
end
