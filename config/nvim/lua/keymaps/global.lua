local wk = require("which-key")

wk.register {
    ["<leader>"] = {
        f = {
            name = "find",
            f = { "<cmd>Telescope find_files<cr>", "find files" },
            h = { "<cmd>Telescope oldfiles<cr>", "recent file" },
            w = { "<cmd>Telescope live_grep<cr>", "find word" },
            m = { "<cmd>Telescope marks<cr>", "open mark" },
            p = { "<cmd>Telescope project<cr>", "open project" },
        },
        c = {
            name = "create",
            f = { "<cmd>DashboardNewFile<cr>", "new file" },
        },
        [","] = {
            name = "settings",
            m = { "<cmd>Telescope filetypes<cr>", "languages" },
            c = { "<cmd>Telescope colorscheme<cr>", "colorscheme" },
        },
        v = {
            name = "view",
            b = { "<cmd>NvimTreeToggle<cr>", "toggle explorer" },
            f = { "<cmd>NvimTreeFindFile<cr>", "focus in explorer" },
            l = { "<cmd>BufferLineCycleNext<cr>", "focus right tab" },
            h = { "<cmd>BufferLineCyclePrev<cr>", "focus left tab" },
            o = { function()
                vim.cmd "BufferLineCloseLeft"
                vim.cmd "BufferLineCloseRight"
            end, "close other tabs" }

        }
    },
    ["<space>"] = {
        name = "super space",
        c = {
            name = "cmake config",
            b = { "<cmd>CMake build<cr>", "select cmake target" },
            c = { "<cmd>CMake configure<cr>", "cmake configure" },
            r = { "<cmd>CMake build_and_debug<cr>", "cmake debug" },
            s = { "<cmd>CMake select_target<cr>", "select cmake target" },
        }
    },
    ["<C-b>"] = { "<cmd>NvimTreeToggle<cr>", "toggle explorer" },
    ["<S-l>"] = { "<cmd>BufferLineCycleNext<cr>", "focus right tab" },
    ["<S-h>"] = { "<cmd>BufferLineCyclePrev<cr>", "focus left tab" }
}
