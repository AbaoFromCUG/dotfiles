local wk = require 'which-key'
local launcher = require 'launcher'
local dap = require 'dap'

vim.api.nvim_set_keymap('n', ';', '<C-w>', { noremap = true })

wk.register {
    ['<leader>'] = {
        f = {
            name = 'find',
            f = { '<cmd>Telescope find_files<cr>', 'find files' },
            h = { '<cmd>Telescope oldfiles<cr>', 'recent file' },
            w = { '<cmd>Telescope live_grep<cr>', 'find word' },
            m = { '<cmd>Telescope marks<cr>', 'open mark' },
            s = { '<cmd>Autosession search<cr>', 'open session' },
        },
        c = {
            name = 'create',
            f = { '<cmd>DashboardNewFile<cr>', 'new file' },
        },
        [','] = {
            name = 'settings',
            m = { '<cmd>Telescope filetypes<cr>', 'languages' },
            c = { '<cmd>Telescope colorscheme<cr>', 'colorscheme' },
        },
        v = {
            name = 'view',
            b = { '<cmd>NvimTreeToggle<cr>', 'toggle explorer' },
            f = { '<cmd>NvimTreeFindFile<cr>', 'focus in explorer' },
            l = { '<cmd>BufferLineCycleNext<cr>', 'focus right tab' },
            h = { '<cmd>BufferLineCyclePrev<cr>', 'focus left tab' },
            o = { function()
                      vim.cmd 'BufferLineCloseLeft'
                      vim.cmd 'BufferLineCloseRight'
                  end, 'close other tabs' }

        }
    },
    ['<space>'] = {
        name = 'super space',
        s = { '<cmd>w<cr>', 'write' },
        c = {
            name = 'cmake config',
            b = { '<cmd>CMake build<cr>', 'select cmake target' },
            c = { '<cmd>CMake configure<cr>', 'cmake configure' },
            r = { '<cmd>CMake build_and_debug<cr>', 'cmake debug' },
            s = { '<cmd>CMake select_target<cr>', 'select cmake target' },
        },
        d = {
            name = 'dap',
            s = { launcher.select_launch_conf, 'select launch' },
            r = { launcher.launch_or_continue, 'debug' },
            t = { dap.terminate, 'termnate' },
            b = { dap.toggle_breakpoint, 'toggle breakpoint' },
            i = { dap.step_into, 'step into' },
            o = { dap.step_over, 'step over' },
            l = { launcher.refresh_launcher, 'refresh config' },
        }
    },
    ['<F5>'] = { launcher.launch_or_continue, 'debug' },
    ['<F6>'] = { dap.terminate, 'termnate' },
    ['<F9>'] = { '<cmd>PBToggleBreakpoint<cr>', 'toggle breakpoint' },
    ['<F11>'] = { dap.step_into, 'step into' },
    ['<F12>'] = { dap.step_over, 'step over' },


    ['<C-b>'] = { '<cmd>NvimTreeToggle<cr>', 'toggle explorer' },
    ['<S-l>'] = { '<cmd>BufferLineCycleNext<cr>', 'focus right tab' },
    ['<S-h>'] = { '<cmd>BufferLineCyclePrev<cr>', 'focus left tab' },
    ['<C-w>Q'] = { '<cmd>qall<cr>', 'Quit all' }
}
