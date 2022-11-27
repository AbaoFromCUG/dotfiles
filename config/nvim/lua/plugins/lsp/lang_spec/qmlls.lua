return function(config)
    local ProjectConfig = require 'cmake.project_config'
    local Path = require 'plenary.path'
    local fn = vim.fn;
    local qmlls_paths = vim.split(fn.globpath('/opt/Qt/', '*/*/bin/qmlls'), '\n')
    local qmlls_path
    if #qmlls_paths > 0 then
        qmlls_path = qmlls_paths[#qmlls_paths]
    else
        qmlls_path = '/usr/lib/qt6/bin/qmlls'
    end


    local project = ProjectConfig.new()
    local build_path = project:get_build_dir()
    local qml_build_dirs = {}

    for _, qmldir_file in ipairs(fn.split(fn.globpath(build_path:absolute(), '**/*/qmldir'), '\n')) do
        local path = Path:new(qmldir_file)
        path = path:parent()
        while path:absolute() ~= build_path:absolute() do
            local qmlmoule_dir = path:absolute()
            if not qml_build_dirs[qmlmoule_dir] then
                qml_build_dirs[qmlmoule_dir] = true
                path = path:parent()
            else
                break
            end
        end
    end

    config.cmd = {
        qmlls_path,
        '-v',
        '--log-file', vim.fn.stdpath 'cache' .. '/qmlls.log',
    }
    for path, _ in pairs(qml_build_dirs) do
        table.insert(config.cmd, '--build-dir')
        table.insert(config.cmd, path)
    end
    config.filetypes = {
        'qml'
    }
end
