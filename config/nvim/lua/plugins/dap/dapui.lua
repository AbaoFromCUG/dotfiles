return function()
    local dap = require("dap")
    local dapui = require("dapui")

    dap.listeners.after.event_initialized["dapui_config"] = function()
        local nvim_tree = require("nvim-tree.api")
        nvim_tree.tree.close()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close(1)
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close(1)
    end

    dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
        },
        element_mappings = {
            stacks = {
                open = "<CR>",
                expand = "o",
            },
            breakpoints = {
                open = "<CR>",
                toggle = "o",
            },
        },
        expand_lines = true,
        layouts = {
            {
                -- open_on_start = true,
                -- You can change the order of elements in the sidebar
                elements = {
                    -- Provide as ID strings or tables with "id" and "size" keys
                    {
                        id = "scopes",
                        size = 0.25, -- Can be float or integer > 1
                    },
                    { id = "breakpoints", size = 0.25 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 00.25 },
                },
                size = 40,
                position = "left", -- Can be "left", "right", "top", "bottom"
            },
            {
                -- open_on_start = true,
                elements = {
                    "repl",
                    "console",
                },
                size = 10,
                position = "bottom", -- Can be "left", "right", "top", "bottom"
            },
        },
        controls = {
            -- Requires Neovim nightly (or 0.8 when released)
            enabled = true,
            -- Display controls in this element
            element = "repl",
            icons = {
                pause = "",
                play = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "",
                terminate = "",
            },
        },
        floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
            mappings = { close = { "q", "<Esc>" } },
        },
        windows = { indent = 1 },
    })
end
