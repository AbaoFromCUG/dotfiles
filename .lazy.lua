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
        [".*/config/tmux/.*"] = "tmux",
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

return {

    {
        "catgoose/nvim-colorizer.lua",
        opts = { filetypes = { "tmux" }, user_default_options = { rgb_fn = true, RRGGBBAA = true } },
        event = "VeryLazy",
    },
}
