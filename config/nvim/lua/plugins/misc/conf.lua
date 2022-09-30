local M = {}

function M.femaco()
    require 'femaco'.setup()
end

function M.glow()
    require 'glow'.setup {
        style = 'dark',
        width = 120, -- your override config
    }
end

return M
