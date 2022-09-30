return function()
    require 'Comment'.setup {
        ---LHS of toggle mappings in NORMAL + VISUAL mode
        ---@type table
        toggler = {
            ---Line-comment toggle keymap
            line = 'g/',
            ---Block-comment toggle keymap
            block = 'gb',
        },
        ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
        ---NOTE: If `mappings = false` then the plugin won't create any mappings
        ---@type boolean|table
        mappings = {
            ---Operator-pending mapping
            ---Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
            ---NOTE: These mappings can be changed individually by `opleader` and `toggler` config
            basic = true,
            ---Extra mapping
            ---Includes `gco`, `gcO`, `gcA`
            extra = false,
            ---Extended mapping
            ---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
            extended = false,
        },
    }
end
