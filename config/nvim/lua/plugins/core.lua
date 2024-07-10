local function profile_start()
    local Path = require("pathlib")
    local profile_path = Path.stdpath("cache", "profile.log")
    ---@diagnostic disable-next-line: param-type-mismatch
    require("plenary.profile").start(tostring(profile_path), { flame = true })
end

local function profile_end()
    local Path = require("pathlib")
    local profile_path = Path.stdpath("cache", "profile.log")
    require("plenary.profile").stop()
    require("plenary.profile").stop()
    if profile_path:is_file() then
        if vim.fn.executable("inferno-flamegraph") then
            local output = vim.fn.system("inferno-flamegraph", tostring(profile_path))
            local flame_path = Path.stdpath("cache", "profile.svg")
            vim.fn.writefile({ output }, tostring(flame_path))
            vim.ui.open(tostring(flame_path))
        end
    end
end

local function smart_close()
    if vim.o["buflisted"] then
        local current_buf = vim.api.nvim_get_current_buf()
        local wins = vim.iter(vim.api.nvim_list_wins())
            :filter(function(win)
                return vim.api.nvim_win_get_buf(win) == current_buf
            end)
            :totable()
        assert(#wins >= 1, "hidden buffer can't smart close")
        if #wins > 1 then
            vim.cmd("quit")
        else
            vim.cmd("BufDel")
        end
    else
        vim.cmd("quit")
    end
end

local function smart_close_others()
    if vim.o["buflisted"] == true then
        vim.cmd("BufDelOthers")
    end
end

---@type (LazySpec|string)[]
return {
    {
        "nvim-lua/plenary.nvim",
        keys = {
            { "<leader>ps", profile_start, desc = "profile start" },
            { "<leader>pe", profile_end, desc = "profile end" },
        },
    },
    "nvim-neotest/nvim-nio",
    "tami5/sqlite.lua",
    "nvim-tree/nvim-web-devicons",
    "pysan3/pathlib.nvim",
    "AbaoFromCUG/websocket.nvim",
    {
        "ojroques/nvim-bufdel",
        cmd = { "BufDel", "BufDelOthers" },
        keys = {
            { ";x", smart_close, desc = "close current buffer" },
            { "<leader>vq", smart_close, desc = "close current buffer" },
            { "<leader>vo", smart_close_others, desc = "close others buffer" },
        },
    },
    {
        "willothy/flatten.nvim",
        config = true,
        lazy = false,
    },

    { "williamboman/mason.nvim", config = true },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "mason.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "lua_ls",
                "pyright",
                "vimls",
                "bashls",
                "clangd",
                "jsonls",
                "yamlls",
                "neocmake",
                "html",
                "cssls",
                "tsserver",
                "volar",
                "texlab",
                "marksman",
                "taplo",
                "ruff_lsp",
                "tailwindcss",
                "eslint",
                "rust_analyzer",
                "stylelint_lsp",
            },
            automatic_installation = true,
        },
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "cppdbg",
                "python",
                "node2",
                "codelldb",
                "js",
            },
            automatic_installation = true,
        },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        opts = {
            ensure_installed = {
                "markdownlint",
            },
            automatic_installation = true,
        },
    },
}
