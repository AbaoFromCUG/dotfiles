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

local function gitsigns()
     require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 100,
            ignore_whitespace = false,
        },
    })
end

local function zen_mode()
    local truezen = require("true-zen")
    truezen.setup({})
end

local function hop()
    require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
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

local function comment()
    require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
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
    -- autopairs
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
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = true,
    },
    -- annotation gen
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = { snippet_engine = "luasnip" },
    },

    -- comment
    { "numToStr/Comment.nvim", config = comment },
    "JoosepAlviste/nvim-ts-context-commentstring",
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
    },

    -- git
    { "lewis6991/gitsigns.nvim", config = gitsigns },
    { "sindrets/diffview.nvim" },
    -- terminal
    { "AbaoFromCUG/terminal.nvim" },
    -- keymap
    {
        "folke/which-key.nvim",
        lazy = true,
        config = true,
    },

    -- zen mode
    { "Pocco81/true-zen.nvim", config = zen_mode },

    -- jump anywhere
    { "phaazon/hop.nvim", config = hop },

    -- session & project
    {
        "AbaoFromCUG/session.nvim",
        dev = true,
        config = session,
    },
}
