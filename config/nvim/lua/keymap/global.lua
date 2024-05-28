local wk = require("which-key")
local trans = require("trans")

vim.keymap.set("n", "<cr>", '{-> v:hlsearch ? ":nohl<CR>" : "<CR>"}()', { expr = true, noremap = true })
vim.keymap.set("n", ";", "<C-w>", { desc = "window", remap = true })

local function smart_format()
    local eslint = vim.lsp.get_clients({ name = "eslint" })[1]

    vim.lsp.buf.format({
        filter = eslint and function(client)
            return client.name ~= "tsserver"
        end or nil,
    })
end

vim.keymap.set("n", "<C-b>", function()
    require("yazi").yazi()
end, { desc = "Open the file manager" })

vim.keymap.set("n", "<leader>cw", function()
    require("yazi").yazi(nil, vim.fn.getcwd())
end, { desc = "Open the file manager in nvim's working directory" })

local is_inside_work_tree = {}
local function project_files()
    local cwd = vim.uv.cwd()
    local builtin = require("telescope.builtin")
    if cwd and is_inside_work_tree[cwd] == nil then
        vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true, cwd = cwd }, function(out)
            is_inside_work_tree[cwd] = out.code == 0
            vim.schedule(project_files)
        end)
    end
    if is_inside_work_tree[cwd] then
        builtin.git_files({ use_git_root = false, show_untracked = true })
    else
        builtin.find_files()
    end
end

wk.register({
    ["<leader>"] = {

        f = {
            name = "find",
            f = { project_files, "find files" },
            h = { "<cmd>Telescope oldfiles<cr>", "history files" },
            w = { "<cmd>Telescope live_grep<cr>", "find words" },
            m = { "<cmd>Telescope marks<cr>", "find marks" },
        },
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
        [","] = {
            name = "settings",
            [","] = { "<cmd>Neoconf local<cr>", "local settings" },
            m = { "<cmd>Telescope filetypes<cr>", "languages" },
            c = { "<cmd>Telescope colorscheme<cr>", "colorscheme" },
        },
    },
    ["<space>"] = {
        name = "super space",
        c = {
            name = "code",
            n = { "<cmd>Neogen<cr>", "neogen" },
            f = { "<cmd>Neogen func<cr>", "neogen function" },
            c = { "<cmd>Neogen class<cr>", "neogen class" },
            t = { "<cmd>Neogen type<cr>", "neogen type" },
        },
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

vim.keymap.set("n", "<leader>S", function()
    require("spectre").toggle()
end, { desc = "Toggle Spectre" })
vim.keymap.set("n", "<leader>sw", function()
    require("spectre").open_visual({ select_word = true })
end, { desc = "Search current word" })
vim.keymap.set("v", "<leader>sw", function()
    require("spectre").open_visual()
end, { desc = "Search current word" })
vim.keymap.set("n", "<leader>sp", function()
    require("spectre").open_file_search({ select_word = true })
end, { desc = "Search on current file" })
