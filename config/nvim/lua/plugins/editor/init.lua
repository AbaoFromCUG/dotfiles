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

---@type LazySpec[]
return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = require("plugins.editor.telescope"),
        cmd = "Telescope",
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
            { "andymass/vim-matchup", opts = {} },
            { "RRethy/nvim-treesitter-endwise" },
            { "nvim-treesitter/nvim-treesitter-refactor" },
            { "nvim-treesitter/nvim-treesitter-textobjects" },
        },
        event = "VeryLazy",
    },
    { "windwp/nvim-ts-autotag", opts = { opts = { enable_close_on_slash = true } }, event = "VeryLazy" },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = { max_lines = 1 },
        dependencies = {
            "nvim-treesitter",
        },
        event = "VeryLazy",
    },
    -- autopairs
    {
        "windwp/nvim-autopairs",
        opts = {
            check_ts = true,
        },
        event = "InsertEnter",
    },
    -- fold
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        config = ufo,
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
        opts = { snippet_engine = "luasnip" },
    },

    -- comment
    { "numToStr/Comment.nvim", config = comment, event = "VeryLazy" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
        event = "VeryLazy",
    },
    -- git
    {
        "lewis6991/gitsigns.nvim",
        config = gitsigns,
        event = "VeryLazy",
    },
    {
        "sindrets/diffview.nvim",
        event = "VeryLazy",
    },
    -- keymap
    {
        "folke/which-key.nvim",
        config = true,
        event = "VeryLazy",
    },

    -- zen mode
    { "folke/zen-mode.nvim", opts = {} },

    {
        "phaazon/hop.nvim",
        config = hop,
        event = "VeryLazy",
    },

    -- session & project
    {
        "AbaoFromCUG/session.nvim",
        config = session,
        event = "VeryLazy",
    },
    {
        "folke/neoconf.nvim",
        config = true,
    },
    {
        "nvim-pack/nvim-spectre",
        config = true,
    },
}
