local conf = require("plugins.editor.conf")

local function ufo()
    vim.o.foldcolumn = "1" -- '0' is not bad
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

    require("ufo").setup({
        provider_selector = function()
            return { "treesitter", "indent" }
        end,
    })
end

local function session()
    require("session").setup({})
    require("session").register_hook("pre_save", "close_all_floating_wins", function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
                vim.api.nvim_win_close(win, false)
            end
        end
    end)
end

local function flatten()
    require("flatten").setup({
        callbacks = {
            pre_open = function()
                -- Close toggleterm when an external open request is received
                require("toggleterm").toggle(0)
            end,
            post_open = function(bufnr, winnr, ft)
                if ft == "gitcommit" then
                    -- If the file is a git commit, create one-shot autocmd to delete it on write
                    -- If you just want the toggleable terminal integration, ignore this bit and only use the
                    -- code in the else block
                    vim.api.nvim_create_autocmd("BufWritePost", {
                        buffer = bufnr,
                        once = true,
                        callback = function()
                            -- This is a bit of a hack, but if you run bufdelete immediately
                            -- the shell can occasionally freeze
                            vim.defer_fn(function()
                                vim.api.nvim_buf_delete(bufnr, {})
                            end, 50)
                        end,
                    })
                else
                    -- If it's a normal file, then reopen the terminal, then switch back to the newly opened window
                    -- This gives the appearance of the window opening independently of the terminal
                    require("toggleterm").toggle(0)
                    vim.api.nvim_set_current_win(winnr)
                end
            end,
            block_end = function()
                -- After blocking ends (for a git commit, etc), reopen the terminal
                require("toggleterm").toggle(0)
            end,
        },
    })
end

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = require("plugins.editor.telescope"),
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    { "nvim-telescope/telescope-dap.nvim" },
    { "nvim-telescope/telescope-symbols.nvim" },
    { "nvim-telescope/telescope-frecency.nvim" },

    -- treesitter highlight
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = require("plugins.editor.treesitter"),
    },
    { "andymass/vim-matchup" },
    { "p00f/nvim-ts-rainbow" },
    { "nvim-treesitter/nvim-treesitter-refactor" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
        },
    },
    -- fold
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        config = ufo,
    },

    -- surround edit
    {
        "kylechui/nvim-surround",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = true,
    },

    -- search and replace
    { "cshuaimin/ssr.nvim", config = true },

    -- annotation gen
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = { snippet_engine = "luasnip" },
    },

    -- comment
    { "numToStr/Comment.nvim", config = true },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
    },

    -- git
    { "lewis6991/gitsigns.nvim", config = conf.gitsigns },

    -- terminal
    { "akinsho/nvim-toggleterm.lua", config = require("plugins.editor.terminal") },
    { "willothy/flatten.nvim", config = flatten },
    {
        "glacambre/firenvim",
        build = function()
            vim.fnk("firenvim#install")(0)
        end,
    },

    -- zen mode
    { "Pocco81/true-zen.nvim", config = conf.zen_mode },

    -- jump anywhere
    { "phaazon/hop.nvim", config = conf.hop },

    -- session
    {
        "AbaoFromCUG/session.nvim",
        config = session,
    },
}
