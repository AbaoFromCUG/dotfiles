local Job = require 'plenary.job'


local M = {}
function M.trans_cursor_word()
    local word = vim.fn.expand '<cword>'
    if (word:match '%w') then
        vim.fn.jobstart('yy -b ' .. word, {
            on_stdout = function(_, data, _)
                if data[1] and #data[1] > 0 then
                    vim.notify(data[1])
                end
            end
        })
    end
end

return M
