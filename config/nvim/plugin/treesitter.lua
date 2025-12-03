vim.filetype.add({
    extension = {
        rasi = "rasi",
        rofi = "rasi",
        wofi = "rasi",
        qml = "qml",
        wgsl = "wgsl",
        pdfpc = "json",
    },
    filename = {
        ["vimrc"] = "vim",
        ["gitconfig"] = "gitconfig",
        ["justfile"] = "just",
    },
    pattern = {
        [".*/.vscode/.*.json"] = "jsonc",
        [".*/.devcontainer/.*.json"] = "jsonc",
        ["%.env%.[%w_.-]+"] = "sh",
    },
})

vim.treesitter.language.register("qmljs", "qml")
vim.treesitter.language.register("bash", "kitty")
vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("json", "jsonl")

vim.api.nvim_set_hl(0, "@attribute_ref_value.vue", { link = "@variable" })

vim.treesitter.query.add_predicate("is-mise?", function(_, _, bufnr, _)
    local filepath = vim.api.nvim_buf_get_name(bufnr or 0)
    local filename = vim.fn.fnamemodify(filepath, ":t")
    return string.match(filename, ".*mise.*%.toml$") ~= nil
end, { force = true, all = false })
