return function()
    require 'neorg'.setup {
        load = {
            ['core.defaults'] = {},
            ['core.norg.dirman'] = {
                config = {
                    workspaces = {
                        notes = '~/Notes',
                    },
                    autochdir = true,
                    index = 'index.norg',
                }
            },
            ['core.norg.completion'] = { config = { engine = 'nvim-cmp' } },
            ['core.norg.concealer'] = {},
            ['core.norg.journal'] = {
                config = {
                }
            },
            ['core.gtd.base'] = {
                config = {
                    workspace = 'notes'
                }

            },
            ['core.norg.qol.toc'] = {
                config = {
                    toc_split_placement = 'right'
                }
            },
            ['core.presenter'] = {
                config = {
                    zen_mode = 'truezen'
                }
            },
            ['core.export'] = {

            },
        }
    }
end
