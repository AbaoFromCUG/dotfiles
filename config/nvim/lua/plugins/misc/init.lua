local conf = require("plugins.misc.conf")

local function cmake()
    -- register command
    require("cmake-tools").setup({
        cmake_build_directory = "build",
        cmake_soft_link_compile_commands = false,
        cmake_dap_configuration = { -- debug settings for cmake
            name = "cpp",
            type = "cppdbg",
            request = "launch",
            stopOnEntry = false,
            runInTerminal = true,
            console = "integratedTerminal",
        },
        cmake_always_use_terminal = false,
        cmake_quickfix_opts = { -- quickfix settings for cmake, quickfix will be used when `cmake_always_use_terminal` is false
            show = "only_on_error", -- "always", "only_on_error"
            position = "belowright", -- "bottom", "top"
            size = 10,
        },
    })
end

return {
    { "Civitasv/cmake-tools.nvim", config = cmake },
    { "AbaoFromCUG/rust-tools.nvim" },
    --[[
    --      Language specific
    --]]
    {
        "ellisonleao/glow.nvim",
        ft = "markdown",
        opts = { style = "dark", width = 120 },
    },
    { "AckslD/nvim-FeMaco.lua", config = true, ft = "markdown" },
    { "nvim-neorg/neorg", config = require("plugins.misc.neorg"), ft = "norg" },
    { "lervag/vimtex", config = conf.tex, ft = "tex" },
    { "rafcamlet/nvim-luapad" },
}
