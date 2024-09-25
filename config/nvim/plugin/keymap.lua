local wk = require("which-key")

vim.keymap.set("n", "<cr>", '{-> v:hlsearch ? ":nohl<CR>" : "<CR>"}()', { expr = true, silent = true, noremap = true })
wk.add({
    { ";", group = "view" },
    { ";-", "<cmd>split<cr>", desc = "split hoizontal" },
    { ";Q", "<cmd>qall<cr>", desc = "quit" },
    { ";h", "<cmd>wincmd h<cr>", desc = "move cursor left" },
    { ";j", "<cmd>wincmd j<cr>", desc = "move cursor down" },
    { ";k", "<cmd>wincmd k<cr>", desc = "move cursor up" },
    { ";l", "<cmd>wincmd l<cr>", desc = "move cursor right" },
    { ";|", "<cmd>vsplit<cr>", desc = "split vertical" },
    { "<leader>,", group = "settings" },
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>l", group = "latex" },
    { "<leader>p", group = "profile" },
    { "<leader>pd", "<cmd>Lazy profile<cr>", desc = "profile bootstrap" },
    { "<leader>s", group = "search" },
    { "<leader>t", group = "tool" },
    { "<leader>v", group = "view" },
    { "<leader>vh", "<cmd>wincmd h<cr>", desc = "move cursor left" },
    { "<leader>vj", "<cmd>wincmd j<cr>", desc = "move cursor down" },
    { "<leader>vk", "<cmd>wincmd k<cr>", desc = "move cursor up" },
    { "<leader>vl", "<cmd>wincmd l<cr>", desc = "move cursor right" },
    { "<leader>vs", "<cmd>split<cr>", desc = "split hoizontal" },
    { "<leader>vv", "<cmd>vsplit<cr>", desc = "split vertical" },
    { "<leader>x", group = "diagnostic" },
    { "<leader>z", group = "zen" },
    { "<space>", group = "super space" },
    { "<space>c", group = "code" },
    { "<space>d", group = "Debugger" },
    { "<space>s", "<cmd>w<cr>", desc = "write" },
    { "<space>t", group = "test" },
})

wk.add({
    {
        mode = { "n", "v" },
        { "<space>P", '"+P', desc = "put before cursor from system clipboard", silent = false },
        { "<space>p", '"+p', desc = "put from system clipboard", silent = false },
        { "<space>x", '"+x', desc = "delete char to system clipboard", silent = false },
        { "<space>y", '"+y', desc = "yank to system clipboard", silent = false },
    },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*" },
    callback = function()
        local ft = vim.fn.expand("<amatch>")

        local console_fts = {
            "PlenaryTestPopup",
        }
        for _, t in ipairs(console_fts) do
            if ft == t then
                require("keymap.consolebuf")(0)
                break
            end
        end
    end,
})
