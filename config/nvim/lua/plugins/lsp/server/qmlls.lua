local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'

local root_files = {
    '.qmlls.ini',
    '*.qmlproject',
    '*.pro',
}

-- Check if the config is already defined (useful when reloading this file)
if not configs.qmlls then
    configs.qmlls = {
        default_config = {
            cmd = { 'qmlls' },
            filetypes = { 'qml', 'qmljs' },
            root_dir = function(fname)
                return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
            end,
            settings = {},
        },
    }
end

