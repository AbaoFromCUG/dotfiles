local wk = require("which-key")


local function context_menu()
    vim.cmd.exec('"normal! \\<RightMouse>"')
    local menu = {
        {
            name = "Format Buffer",
            cmd = function()
                require("utils.format")()
            end,
            rtxt = "<space>f",
        },

        {
            name = "Code Actions",
            cmd = vim.lsp.buf.code_action,
            rtxt = "gra",
        },

        { name = "separator" },

        {
            name = "  Lsp Actions",
            hl = "Exblue",
            items = "lsp",
        },

        { name = "separator" },

        {
            name = "Edit Config",
            cmd = function()
                vim.cmd "tabnew"
                local conf = vim.fn.stdpath "config"
                vim.cmd("tcd " .. conf .. " | e init.lua")
            end,
            rtxt = "ed",
        },

        {
            name = "Copy Content",
            cmd = "%y+",
            rtxt = "<C-c>",
        },

        {
            name = "Delete Content",
            cmd = "%d",
            rtxt = "dc",
        },

        { name = "separator" },

        {
            name = "  Open in terminal",
            hl = "ExRed",
            cmd = function()
                local old_buf = require("menu.state").old_data.buf
                local old_bufname = vim.api.nvim_buf_get_name(old_buf)
                local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")

                local cmd = "cd " .. old_buf_dir
                vim.cmd "enew"
                vim.fn.jobstart({ vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell }, { term = true })
            end,
        },

        { name = "separator" },

        {
            name = "  Color Picker",
            cmd = function()
                require("minty.huefy").open()
            end,
        },
    }
    require("menu").open(menu, { mouse = true })
end

vim.keymap.set("n", "<cr>", '{-> v:hlsearch ? ":nohl<CR>" : "<CR>"}()', { expr = true, silent = true, noremap = true })

wk.add({
    { ";",            group = "view" },
    { ";-",           "<cmd>split<cr>",        desc = "split hoizontal" },
    { ";Q",           "<cmd>qall<cr>",         desc = "quit" },
    { ";h",           "<cmd>wincmd h<cr>",     desc = "goto left" },
    { ";j",           "<cmd>wincmd j<cr>",     desc = "goto down" },
    { ";k",           "<cmd>wincmd k<cr>",     desc = "goto up" },
    { ";l",           "<cmd>wincmd l<cr>",     desc = "goto right" },
    { ";w",           "<cmd>wincmd w<cr>",     desc = "goto float" },
    { ";q",           "<cmd>wincmd q<cr>",     desc = "close window" },
    { ";o",           "<cmd>wincmd o<cr>",     desc = "close other windows" },
    { ";|",           "<cmd>vsplit<cr>",       desc = "split vertical" },
    { "<leader>,",    group = "settings" },
    { "<leader>f",    group = "find" },
    { "<leader>g",    group = "git" },
    { "<leader>l",    group = "latex" },
    { "<leader>p",    group = "profile" },
    { "<leader>pd",   "<cmd>Lazy profile<cr>", desc = "profile bootstrap" },
    { "<leader>s",    group = "search" },
    { "<leader>t",    group = "tool" },
    { "<leader>v",    group = "view" },
    { "<leader>vh",   "<cmd>wincmd h<cr>",     desc = "move cursor left" },
    { "<leader>vj",   "<cmd>wincmd j<cr>",     desc = "move cursor down" },
    { "<leader>vk",   "<cmd>wincmd k<cr>",     desc = "move cursor up" },
    { "<leader>vl",   "<cmd>wincmd l<cr>",     desc = "move cursor right" },
    { "<leader>vs",   "<cmd>split<cr>",        desc = "split hoizontal" },
    { "<leader>vv",   "<cmd>vsplit<cr>",       desc = "split vertical" },
    { "<leader>x",    group = "diagnostic" },
    { "<leader>z",    group = "zen" },
    { "<space>",      group = "super space" },
    { "<space>c",     group = "code" },
    { "<space>d",     group = "Debugger" },
    { "<space>s",     "<cmd>w<cr>",            desc = "write" },
    { "<space>t",     group = "test" },

    { "<RightMouse>", context_menu,            desc = "context menu" },
})

wk.add({
    { "<space>P", '"+P', desc = "put before cursor from system clipboard" },
    { "<space>p", '"+p', desc = "put from system clipboard" },
    { "<space>x", '"+x', desc = "delete char to system clipboard" },
    { "<space>y", '"+y', desc = "yank to system clipboard" },
    mode = { "n", "v" },
    silent = false,
})
