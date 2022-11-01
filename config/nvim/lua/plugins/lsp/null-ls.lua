return function()
    local null_ls = require 'null-ls'
    local methods = require 'null-ls.methods'
    local helpers = require 'null-ls.helpers'
    local qmlformat_paths = vim.split(vim.fn.globpath('/opt/Qt/', '*/*/bin/qmlformat'), '\n')
    local qmlformat_path
    if #qmlformat_paths > 0 then
        qmlformat_path = qmlformat_paths[#qmlformat_paths]
    else
        qmlformat_path = '/usr/lib/qt6/bin/qmlformat'
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
            command = qmlformat_path,
            args = { '--inplace', '$FILENAME' },
            to_temp_file = true,
        },
    }


    null_ls.setup {
        sources = {
            qmlformat,
            null_ls.builtins.formatting.autopep8,
            null_ls.builtins.formatting.cmake_format,
            null_ls.builtins.formatting.shfmt,
            null_ls.builtins.formatting.yamlfmt,
        },
    }
end
