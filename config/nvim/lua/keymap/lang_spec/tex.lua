return function(bufno)
    local requests = require("texlab.requests")
    local previewer = require("texlab.previewer")
    vim.keymap.set("n", "<space><space>", requests.build, { buffer = bufno, desc = "latex build" })
    vim.keymap.set("n", "<space>b", previewer.start, { buffer = bufno, desc = "latex build" })
end
