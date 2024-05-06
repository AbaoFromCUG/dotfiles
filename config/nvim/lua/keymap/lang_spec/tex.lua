local wk = require("which-key")

return function(bufno)
    wk.register({}, {
        buffer = bufno,
        silent = false,
    })
end
