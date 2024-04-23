local which_key = require("which-key")

return function(bufno)
    which_key.register({
        ["<space>"] = {
            x = { ":Neopyter run current<CR>", "run current cell" },
            X = { ":Neopyter run allAbove<CR>", "run all above cell" },
            n = {
                name = "Jupyter lab",
                t = { ":Neopyter kernel restart<CR>", "restart kernel" },
            },
        },
    }, {
        buffer = bufno,
        silent = false,
    })
end
