local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'
local null_ls = require('null-ls')
local methods = require('null-ls.methods')
local helpers = require('null-ls.helpers')

local root_files = {
    'compile_commands.json',
    '*.qmlproject',
    '*.pro',
}

-- Check if the config is already defined (useful when reloading this file)
if not configs.qmlls then
    configs.qmlls = {
        default_config = {
            cmd = { '/usr/lib/qt6/bin/qmlls', '-v' },
            filetypes = { 'qml', 'qmljs' },
            root_dir = function(fname)
                return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
            end,
            settings = {},
        },
    }
end

local qmlformat = {
    name = 'qmlformat',
    meta = {
        url = 'https://doc.qt.io/qt-6/qtquick-tools-and-utilities.html',
        description = 'Formats QML files according to the QML Coding Conventions.'
    },
    method = { methods.internal.FORMATTING },
    filetypes = { 'qml', 'qmljs' },
    generator = helpers.formatter_factory {
        command = '/usr/lib/qt6/bin/qmlformat',
        args = { '--inplace', '$FILENAME' },
        to_temp_file = true,
    },
}
null_ls.register(qmlformat)
