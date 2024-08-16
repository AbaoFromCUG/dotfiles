local kulala = require("kulala")

require("which-key").add({
    { "<space>rr", kulala.run, desc = "run current" },
    buffer = 0,
})
