local wk = require("which-key")

return function(bufno)
    wk.register({
        ["<space>"] = {
            ["<space>"] = { "<cmd>MarkdownPreview<cr>", "preview markdown" },
        },
    }, {
        buffer = bufno,
        silent = false,
    })
end
