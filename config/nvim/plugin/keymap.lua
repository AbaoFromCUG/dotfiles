
local wk = require("which-key")

vim.keymap.set("n", "<cr>", '{-> v:hlsearch ? ":nohl<CR>" : "<CR>"}()', { expr = true, silent = true, noremap = true })

wk.register({
    [";"] = {
        name = "view",
        h = { "<cmd>wincmd h<cr>", "move cursor left" },
        j = { "<cmd>wincmd j<cr>", "move cursor down" },
        k = { "<cmd>wincmd k<cr>", "move cursor up" },
        l = { "<cmd>wincmd l<cr>", "move cursor right" },

        Q = { "<cmd>qall<cr>", "quit" },

        ["-"] = { "<cmd>split<cr>", "split hoizontal" },
        ["|"] = { "<cmd>vsplit<cr>", "split vertical" },
    },

    ["<leader>"] = {
        f = {
            name = "find",
        },
        g = {
            name = "git",
        },
        p = {
            name = "profile",
            d = { "<cmd>Lazy profile<cr>", "profile bootstrap" },
        },
        s = { name = "search" },
        t = { name = "translate" },
        v = {
            name = "view",
            h = { "<cmd>wincmd h<cr>", "move cursor left" },
            j = { "<cmd>wincmd j<cr>", "move cursor down" },
            k = { "<cmd>wincmd k<cr>", "move cursor up" },
            l = { "<cmd>wincmd l<cr>", "move cursor right" },
            s = { "<cmd>split<cr>", "split hoizontal" },
            v = { "<cmd>vsplit<cr>", "split vertical" },
        },
        x = {
            name = "diagnostic",
        },
        z = {
            name = "zen",
        },
        [","] = {
            name = "settings",
        },
    },
    ["<space>"] = {
        name = "super space",
        c = {
            name = "code",
        },
        d = {
            name = "Debugger",
        },
        s = { "<cmd>w<cr>", "write" },
        t = {
            name = "test",
        },
    },
})

wk.register({
    y = { '"+y', "yank to system clipboard" },
    p = { '"+p', "put from system clipboard" },
    P = { '"+P', "put before cursor from system clipboard" },
    d = { '"+d', "delete to system clipboard" },
    x = { '"+x', "delete char to system clipboard" },
}, { prefix = "<space>", silent = false, mode = { "n", "v", "x" } })

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
