return function()
    local lspconfig = require 'lspconfig'
    local lspkeymap_register = require 'keymap.lspbuffer'
    -- reference https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

    require 'plugins.lsp.server.neocmake'

    local code_navigation = require 'nvim-navic'

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
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'
    -- config that activates keymaps and enables snippet support
    local function make_config()
        local capabilities = cmp_nvim_lsp.default_capabilities()
        return {
            capabilities = capabilities,
            -- map buffer local keybindings when the language server attaches
            on_attach = on_attach,
        }
    end

    local servers = {
        'clangd',
        'sumneko_lua',
        'pyright',
        'neocmake',
        'vimls',
        'bashls',
        'qmlls',
        'jsonls',
        'yamlls',
        'tsserver',
    }
    for _, server_name in ipairs(servers) do
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
