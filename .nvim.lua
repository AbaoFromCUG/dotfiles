-- vim.lsp.enable("lua_ls")

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
    },
})
