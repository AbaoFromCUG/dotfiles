return function()
    local notify = require "notify"
    vim.notify = notify
    notify.setup {}
end
