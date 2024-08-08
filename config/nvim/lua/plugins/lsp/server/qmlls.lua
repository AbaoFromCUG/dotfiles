local Path = require("pathlib")
local util = require("lspconfig.util")

local root_files = {
    ".qmlls.ini",
    "CMakeLists.txt",
}

return function(config)
    local fn = vim.fn
    local qmlls_path = "/usr/lib/qt6/bin/qmlls"

    config.cmd = {
        qmlls_path,
        "-v",
        "--no-cmake-calls",
        "--log-file",
        vim.fn.stdpath("cache") .. "/qmlls.log",
    }
    config.root_dir = function(fname)
        return util.root_pattern(unpack(root_files))(fname)
    end
end
