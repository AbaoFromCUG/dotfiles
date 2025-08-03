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
        ["vifmrc"] = "vim",
        ["gitconfig"] = "gitconfig",
        ["justfile"] = "just",
    },
    pattern = {
        [".*/.vscode/.*.json"] = "jsonc",
        ["%.env%.[%w_.-]+"] = "sh",
    },
})

vim.treesitter.language.register("qmljs", "qml")
vim.treesitter.language.register("bash", "kitty")
vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("json", "jsonl")

vim.api.nvim_set_hl(0, "@attribute_ref_value.vue", { link = "@variable" })
