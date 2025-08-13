return {
    {
        "SUSTech-data/neopyter",
        dependencies = {
            "AbaoFromCUG/websocket.nvim",
        },
        ---@type neopyter.Option
        opts = {
            auto_attach = true,
            on_attach = function(buf)
                require("which-key").add({
                    { "<space>nt", "<cmd>Neopyter execute kernelmenu:restart<cr>",       desc = "restart kernel" },
                    { "<C-CR>",    "<cmd>Neopyter execute notebook:run-cell<cr>",        desc = "run selected" },
                    { "<space>nr", "<cmd>Neopyter execute notebook:run-cell<cr>",        desc = "run selected" },
                    { "<space>nR", "<cmd>Neopyter run all<cr>",                          desc = "run all" },
                    { "<F5>",      "<cmd>Neopyter execute notebook:restart-run-all<cr>", desc = "restart kernel and run all" },

                    buffer = buf,
                })
            end,
            jupyter = {
                scroll = {
                    enable = true,
                    align = "auto",
                },
            },
            highlight = {
                enable = true,
                mode = "separator",
            },
            textobject = {
                enable = true,
                queries = { "cellseparator", "cellcontent", "cell" },
            },
            parser = {
                trim_whitespace = true,
            },
        },
        ft = { "python", "r" },
        cmd = "Neopyter",
        dev = true
    },
    {
        "saghen/blink.cmp",
        opts = function(_, opts)
            table.insert(opts.sources.per_filetype.python, "neopyter")
            opts.sources.providers.neopyter = {
                name = "Neopyter",
                module = "neopyter.blink",
                ---@type neopyter.CompleterOption
                opts = {},
            }
        end,
    },
}
