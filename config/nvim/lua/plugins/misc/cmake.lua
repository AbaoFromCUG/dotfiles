return function()
    local cmake = require 'cmake'
    local Path = require 'plenary.path'
    cmake.setup {
        -- JSON file to store information about selected target, run arguments and build type.
        parameters_file = '.neovim/cmake.json',
        -- Build directory. The expressions `{cwd}`, `{os}` and `{build_type}` will be expanded with the corresponding text values.
        build_dir = tostring(Path:new('{cwd}', 'build', '{os}-{build_type}')),
        -- Default folder for creating project.
        default_projects_path = tostring(Path:new(vim.loop.os_homedir(), 'Documents')),
        -- Default arguments that will be always passed at cmake configure step. By default tells cmake to generate `compile_commands.json`.
        configure_args = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },
        build_args = {}, -- Default arguments that will be always passed at cmake build step.
        -- Height of the opened quickfix.
        quickfix_height = 10,
        dap_configuration = { type = 'gdb', request = 'launch' },
        dap_open_command = require 'dap'.repl.open,
        copy_compile_commands = false,
    }
end
