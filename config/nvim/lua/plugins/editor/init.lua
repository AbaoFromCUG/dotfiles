local function autopairs()
    local npairs = require("nvim-autopairs")

    npairs.setup({
        check_ts = true,
    })
end

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
    require("session").setup({ silent_restore = false })
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
    ---@diagnostic disable-next-line: missing-fields
    require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
end

local function _spectre()
    local spectre = require("spectre")
    spectre.setup()
    vim.keymap.set("n", "<leader>S", spectre.toggle, { desc = "Toggle Spectre" })
    vim.keymap.set("n", "<leader>sw", function()
        spectre.open_visual({ select_word = true })
    end, { desc = "Search current word" })
    vim.keymap.set("v", "<leader>sw", spectre.open_visual, { desc = "Search current word" })
    vim.keymap.set("n", "<leader>sp", function()
        spectre.open_file_search({ select_word = true })
    end, { desc = "Search on current file" })
end

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = require("plugins.editor.telescope"),
        lazy = true,
        event = "VeryLazy",
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    { "nvim-telescope/telescope-symbols.nvim" },
    { "nvim-telescope/telescope-frecency.nvim" },

    -- tree-sitter highlight
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = require("plugins.editor.treesitter"),
        dependencies = {
            { "andymass/vim-matchup", opts = {}, lazy = true },
            { "RRethy/nvim-treesitter-endwise", lazy = true },
            { "nvim-treesitter/nvim-treesitter-refactor", lazy = true },
            { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
            { "windwp/nvim-ts-autotag", lazy = true },
        },
        lazy = true,
        event = "VeryLazy",
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = { max_lines = 1 },
        dependencies = {
            "nvim-treesitter",
        },
        lazy = true,
        event = "VeryLazy",
    },
    -- autopairs
    {
        "windwp/nvim-autopairs",
        -- event = "InsertEnter",
        opts = autopairs,
        lazy = true,
    },
    -- fold
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        config = ufo,
        lazy = true,
        event = "VeryLazy",
    },
    -- surround edit
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        opts = {
            surrounds = {
                ["("] = {
                    add = { "(", ")" },
                },
            },
        },
    },
    -- annotation gen
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = { snippet_engine = "luasnip" },
        lazy = true,
        event = "VeryLazy",
    },

    -- comment
    { "numToStr/Comment.nvim", config = comment, lazy = true, event = "VeryLazy" },
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
    },
    -- git
    { "lewis6991/gitsigns.nvim", config = gitsigns },
    { "sindrets/diffview.nvim" },
    -- keymap
    {
        "folke/which-key.nvim",
        config = true,
    },

    -- zen mode
    { "Pocco81/true-zen.nvim", config = zen_mode },

    -- jump anywhere
    { "phaazon/hop.nvim", config = hop },

    -- session & project
    {
        "AbaoFromCUG/session.nvim",
        config = session,
        dependencies = { "nvim-treesitter" },
        lazy = true,
        event = "VeryLazy",
    },

    -- project-local config
    {
        "folke/neoconf.nvim",
        lazy = true,
        config = true,
    },
    { "nvim-pack/nvim-spectre", config = _spectre, lazy = true, event = "UIEnter" },
}
