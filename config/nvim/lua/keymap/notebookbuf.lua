local which_key = require("which-key")

return function(bufno)
    which_key.register({
        ["<space>"] = {
            x = { ":Neopyter run current<CR>", "run current cell" },
            X = { ":Neopyter run allAbove<CR>", "run all above cell" },
        },
    }, {
        buffer = bufno,
        silent = false,
    })
end
