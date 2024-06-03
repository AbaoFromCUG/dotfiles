local is_inside_work_tree = {}

local function project_files()
    local cwd = vim.uv.cwd()
    local builtin = require("telescope.builtin")
    if cwd and is_inside_work_tree[cwd] == nil then
        vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true, cwd = cwd }, function(out)
            is_inside_work_tree[cwd] = out.code == 0
            vim.schedule(project_files)
        end)
    end
    if is_inside_work_tree[cwd] then
        builtin.git_files({ use_git_root = false, show_untracked = true })
    else
        builtin.find_files()
    end
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
        keys = {
            { "<leader>ff", project_files, desc = "find files" },
            { "<leader>fh", "<cmd>Telescope oldfiles<cr>", desc = "history files" },
            { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "find words" },
            { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "find marks" },
            { "<leader>,m", "<cmd>Telescope filetypes<cr>", desc = "change languages" },
            { "<leader>,c", "<cmd>Telescope colorscheme<cr>", desc = "change colorscheme" },
        },
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
        opts = {},
    },
    -- annotation gen
    {
        "danymat/neogen",
        opts = { snippet_engine = "luasnip" },
        cmd = "Neogen",
        keys = {
            { "<space>cn", "<cmd>Neogen<cr>", desc = "neogen" },
            { "<space>cf", "<cmd>Neogen func<cr>", desc = "neogen function" },
            { "<space>cc", "<cmd>Neogen class<cr>", desc = "neogen class" },
            { "<space>ct", "<cmd>Neogen type<cr>", desc = "neogen type" },
        },
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
    {
        "folke/zen-mode.nvim",
        opts = {},
        keys = {
            { "<leader>zz", "<cmd>ZenMode<cr>", mode = { "n", "i", "v" }, desc = "zen mode" },
        },
    },

    {
        "folke/flash.nvim",
        ---@type Flash.Config
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
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
        keys = {
            { "<leader>,,", "<cmd>Neoconf local<cr>", "local settings" },
        },
    },
    {
        "nvim-pack/nvim-spectre",
        config = true,
        cmd = "Spectre",
        keys = {
            { "<leader>ss", "<cmd>Spectre<cr>", desc = "Select current word" },
            { "<leader>sw", "<cmd>Spectre select_word=true<cr>", desc = "Select current word" },
        },
    },
}
