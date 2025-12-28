
vim.filetype.add({
    filename = {
        ["zprofile"] = "zsh",
        ["zshrc"] = "zsh",
        ["zshenv"] = "zsh",
    },
    pattern = {
        [".*/sway/.*"] = "swayconfig",
        [".*/waybar/config"] = "jsonc",
        [".*/mako/config"] = "dosini",
        [".*/kitty/.+%.conf"] = "kitty",
        [".*/hypr/.+%.conf"] = "hyprlang",
        [".*/config/git/.*"] = "gitconfig",
    },
})
vim.lsp.config("pyright", {
    ---@type lspconfig.settings.pyright
    settings = {
        python = {
            analysis = {
                extraPaths = { "/usr/lib/kitty/" },
            },
        },
    },
})
