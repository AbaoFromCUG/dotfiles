local wk = require("which-key")

vim.keymap.set("n", "<cr>", '{-> v:hlsearch ? ":nohl<CR>" : "<CR>"}()', { expr = true, silent = true, noremap = true })
vim.keymap.set("n", ";", "<C-w>", { desc = "window", remap = true })

local function smart_format()
    local eslint = vim.lsp.get_clients({ name = "eslint" })[1]
    vim.lsp.buf.format({ filter = eslint and function(client)
        return client.name ~= "tsserver"
    end or nil })
end

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

wk.register({
    ["<C-w>Q"] = { "<cmd>qall<cr>", "quit all" },
    ["<leader>"] = {
        f = {
            name = "find",
        },
        p = {
            name = "profile",
            d = { "<cmd>Lazy profile<cr>", "profile bootstrap" },
            s = { profile_start, "profile start" },
            e = { profile_end, "profile end" },
        },
        s = { name = "search" },
        t = { name = "translate" },
        v = {
            name = "view",
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
        f = { smart_format, "format" },
    },
})

wk.register({
    y = { '"+y', "yank to system clipboard" },
    p = { '"+p', "put from system clipboard" },
    P = { '"+P', "put before cursor from system clipboard" },
    d = { '"+d', "delete to system clipboard" },
    x = { '"+x', "delete char to system clipboard" },
}, { prefix = "<space>", silent = false, mode = { "n", "v", "x" } })
