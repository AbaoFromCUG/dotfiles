local wk = require("which-key")
local launcher = require("launcher")
local dap = require("dap")
local trans = require("trans")

vim.api.nvim_set_keymap("n", "<cr>", '{-> v:hlsearch ? ":nohl<CR>" : "<CR>"}()', { expr = true, noremap = true })
vim.api.nvim_set_keymap("n", ";", "<C-w>", { noremap = true })

wk.register({
    ["<leader>"] = {
        f = {
            name = "find",
            f = { "<cmd>Telescope find_files<cr>", "find files" },
            h = { "<cmd>Telescope oldfiles<cr>", "recent file" },
            w = { "<cmd>Telescope live_grep<cr>", "find word" },
            m = { "<cmd>Telescope marks<cr>", "open mark" },
            s = { "<cmd>Autosession search<cr>", "open session" },
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
            o = {
                function()
                    vim.cmd("BufferLineCloseLeft")
                    vim.cmd("BufferLineCloseRight")
                end,
                "close other tabs",
            },
        },
        z = {
            name = "zen or fold",
            n = { "<cmd>TZNarrow<cr>", "toggle narrow mode" },
            f = { "<cmd>TZFocus<cr>", "toggle focus mode" },
            m = { "<cmd>TZMinimalist<cr>", "toggle minimalist mode" },
            a = { "<cmd>TZAtaraxis<cr>", "toggle ataraxis mode" },
            R = { require("ufo").openAllFolds, "Open All Folds" },
            M = { require("ufo").closeAllFolds, "Close All Folds" },
        },
    },
    ["<space>"] = {
        name = "super space",
        s = { "<cmd>w<cr>", "write" },
        t = { trans.trans_cursor_word, "translate" },
        d = {
            name = "Debugger",
            s = { launcher.select_launch_conf, "select launch" },
            r = { launcher.run, "run" },
            t = { launcher.terminate, "termnate" },
            b = { launcher.build, "build" },
            l = { launcher.refresh_launcher, "refresh config" },
        },
        f = { vim.lsp.buf.format, "format" },
    },

    ["<F5>"] = { launcher.launch_or_continue, "debug" },
    ["<F6>"] = { dap.terminate, "termnate" },
    ["<F9>"] = { "<cmd>PBToggleBreakpoint<cr>", "toggle breakpoint" },
    ["<F11>"] = { dap.step_into, "step into" },
    ["<F12>"] = { dap.step_over, "step over" },

    ["<C-b>"] = { "<cmd>NvimTreeToggle<cr>", "toggle explorer" },
    ["<S-l>"] = { "<cmd>BufferLineCycleNext<cr>", "focus right tab" },
    ["<S-h>"] = { "<cmd>BufferLineCyclePrev<cr>", "focus left tab" },
    ["<C-w>Q"] = { "<cmd>qall<cr>", "Quit all" },
    ["f"] = { "<cmd>HopWord<cr>", "Hop word" },
})

vim.keymap.set({ "n", "x" }, "<leader>sr", function()
    require("ssr").open()
end)
wk.register({
    y = { '"+y', "yank to system clipboard" },
    p = { '"+p', "put from system clipboard" },
}, { prefix = "<leader>", silent = false, mode = { "n", "v", "x" } })

wk.register({
    ["<leader>"] = {
        z = {
            name = "zen mode",
            n = { ":'<,'>TZNarrow<CR>", "toogle zen mode" },
        },
    },
}, {
    mode = "v",
})
