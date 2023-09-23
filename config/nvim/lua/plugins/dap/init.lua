local function _overseer()
    require("overseer").setup({
        templates = { "builtin" },

        strategy = {
            "terminal",
        },
    })
end

return {
    {
        "mfussenegger/nvim-dap",
        config = require("plugins.dap.dap"),
    },
    {
        "AbaoFromCUG/integrator.nvim",
        opts = {
            dap = { enabled = true },
            session = { enabled = true },
            settings = { enabled = true },
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-dap",
        config = require("plugins.dap.dapui"),
    },
    { "theHamsta/nvim-dap-virtual-text", config = true },
    { "Weissle/persistent-breakpoints.nvim", config = true },
    { "stevearc/overseer.nvim", config = _overseer },
}
