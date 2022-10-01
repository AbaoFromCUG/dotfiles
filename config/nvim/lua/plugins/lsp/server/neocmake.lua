local configs = require 'lspconfig.configs'
local nvim_lsp = require 'lspconfig'
if not configs.neocmake then
    configs.neocmake = {
        default_config = {
            cmd = { 'neocmakelsp', '--stdio' },
            filetypes = { 'cmake' },
            root_dir = function(fname)
                return nvim_lsp.util.find_git_ancestor(fname)
            end,
            single_file_support = true, -- suggested
        }
    }
end
