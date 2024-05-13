local wk = require("which-key")
local trans = require("trans")

vim.api.nvim_set_keymap("n", "<cr>", '{-> v:hlsearch ? ":nohl<CR>" : "<CR>"}()', { expr = true, noremap = true })
vim.api.nvim_set_keymap("n", ";", "<C-w>", { noremap = true })

local function smart_format()
    vim.lsp.buf.format({
        filter = function(client)
            return client.name ~= "tsserver"
        end,
    })
end

vim.keymap.set("n", "<C-b>", function()
    require("yazi").yazi()
end, { desc = "Open the file manager" })

vim.keymap.set("n", "<leader>cw", function()
    require("yazi").yazi(nil, vim.fn.getcwd())
end, { desc = "Open the file manager in nvim's working directory" })

wk.register({
    ["<leader>"] = {
        c = { name = "generate" },
        f = { name = "find" },
        s = { name = "search" },
        t = { name = "translate" },
        v = {
            name = "view",
            o = {
                function()
                    vim.cmd("BufferLineCloseLeft")
                    vim.cmd("BufferLineCloseRight")
                end,
                "close other tabs",
            },
        },
        z = {
            name = "zen",
            n = { "<cmd>TZNarrow<cr>", "toggle narrow mode" },
            f = { "<cmd>TZFocus<cr>", "toggle focus mode" },
            m = { "<cmd>TZMinimalist<cr>", "toggle minimalist mode" },
            a = { "<cmd>TZAtaraxis<cr>", "toggle ataraxis mode" },
        },
        [","] = {
            name = "settings",
            [","] = { "<cmd>Neoconf local<cr>", "local settings" },
            m = { "<cmd>Telescope filetypes<cr>", "languages" },
            c = { "<cmd>Telescope colorscheme<cr>", "colorscheme" },
        },
    },
    ["<space>"] = {
        name = "super space",
        d = {
            name = "Debugger",
        },
        s = { "<cmd>w<cr>", "write" },
        t = {
            name = "test",
        },
        f = { smart_format, "format" },
    },

    ["<S-l>"] = { "<cmd>BufferLineCycleNext<cr>", "focus right tab" },
    ["<S-h>"] = { "<cmd>BufferLineCyclePrev<cr>", "focus left tab" },
    ["<C-w>Q"] = { "<cmd>qall<cr>", "Quit all" },
    ["f"] = { "<cmd>HopWord<cr>", "Hop word" },
})

wk.register({
    y = { '"+y', "yank to system clipboard" },
    p = { '"+p', "put from system clipboard" },
    P = { '"+P', "put before cursor from system clipboard" },
    d = { '"+d', "delete to system clipboard" },
    x = { '"+x', "delete char to system clipboard" },
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
