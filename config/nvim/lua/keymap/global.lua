local wk = require("which-key")
local dap = require("dap")
local neotest = require("neotest")
local builtin = require("telescope.builtin")
local trans = require("trans")

vim.api.nvim_set_keymap("n", "<cr>", '{-> v:hlsearch ? ":nohl<CR>" : "<CR>"}()', { expr = true, noremap = true })
vim.api.nvim_set_keymap("n", ";", "<C-w>", { noremap = true })

local is_inside_work_tree = {}
local function project_files()
    local cwd = vim.uv.cwd()
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

local function smart_run()
    if dap.session() then
        dap.continue()
    else
        dap.run_last()
    end
end

wk.register({
    ["<leader>"] = {
        f = {
            name = "find",
            f = { project_files, "find files" },
            h = { "<cmd>Telescope oldfiles<cr>", "recent file" },
            w = { "<cmd>Telescope live_grep<cr>", "find word" },
            m = { "<cmd>Telescope marks<cr>", "open mark" },
            s = { "<cmd>Session open<cr>", "open session" },
        },
        c = {
            name = "generate",
            a = { "<cmd>Neogen<cr>", "generate annotation" },
        },
        t = { trans.trans_cursor_word, "translate" },
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
            name = "zen",
            n = { "<cmd>TZNarrow<cr>", "toggle narrow mode" },
            f = { "<cmd>TZFocus<cr>", "toggle focus mode" },
            m = { "<cmd>TZMinimalist<cr>", "toggle minimalist mode" },
            a = { "<cmd>TZAtaraxis<cr>", "toggle ataraxis mode" },
        },
        [","] = {
            name = "settings",
            m = { "<cmd>Telescope filetypes<cr>", "languages" },
            c = { "<cmd>Telescope colorscheme<cr>", "colorscheme" },
        },
    },
    ["<space>"] = {
        name = "super space",
        d = {
            name = "Debugger",
            r = { smart_run, "run" },
        },
        s = { "<cmd>w<cr>", "write" },
        t = {
            name = "Test",
            f = {
                function()
                    neotest.run.run(vim.fn.expand("%"))
                end,
                "test current file",
            },
            t = {
                function()
                    neotest.run.run()
                end,
                "test nearest case",
            },
        },

        f = {
            function()
                vim.lsp.buf.format({
                    filter = function(client)
                        return client.name ~= "tsserver"
                    end,
                })
            end,
            "format",
        },
    },

    ["<F5>"] = { smart_run, "run" },
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
