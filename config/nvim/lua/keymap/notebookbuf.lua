local which_key = require("which-key")

return function(bufno)
    which_key.register({
        ["<space>"] = {
            x = { "<cmd>Neopyter run current<cr>", "run current cell" },
            X = { "<cmd>Neopyter run allAbove<cr>", "run all above cell" },
            n = {
                name = "Jupyter lab",
                t = { ":Neopyter kernel restart<cr>", "restart kernel" },
            },
        },
    }, {
        buffer = bufno,
        silent = false,
    })
end
