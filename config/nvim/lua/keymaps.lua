local wk = require("which-key")
local dap = require("dap")

local function run()
    if dap.session() then
        vim.cmd("DapContinue")
    else
        vim.cmd("CMake build_and_run")
    end
end

local function step_over()
    if dap.session() then
        vim.api.cmd("DapStepOver")
    end
end

local function step_into()
    if dap.session() then
        vim.api.cmd("DapStepInto")
    end
end

local function breakpoint()
    vim.cmd("DapToggleBreakpoint")
end

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
    },
    ["<space>"] = {
        name = "super space",
        r = { run, "run" },
        n = { step_over, "step over" },
        N = { step_into, "step into" },
        p = { breakpoint, "toggle breakpoint" },
        b = { "<cmd>NvimTreeToggle<cr>", "toggle explorer" },
        f = { "<cmd>NvimTreeFindFile<cr>", "focus in explorer" },

        l = { "<cmd>BufferLineCycleNext<cr>", "focus right tab" },
        h = { "<cmd>BufferLineCyclePrev<cr>", "focus left tab" },
        o = { function()
            vim.cmd "BufferLineCloseLeft"
            vim.cmd "BufferLineCloseRight"
        end, "close other tabs" }
    },
    ["<C-b>"] = { "<cmd>NvimTreeToggle<cr>", "toggle explorer" },
    ["<S-l>"] = { "<cmd>BufferLineCycleNext<cr>", "focus right tab" },
    ["<S-h>"] = { "<cmd>BufferLineCyclePrev<cr>", "focus left tab" }
}
