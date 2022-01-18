return function()
    require("nvim-gps").setup {
        languages = {
            ["c"] = true,
            ["cpp"] = true,
            ["go"] = true,
            ["java"] = true,
            ["javascript"] = true,
            ["lua"] = true,
            ["python"] = true,
            ["rust"] = true,
            ["shell"] = true,
            ["json"] = true,
            ["yaml"] = true,
        },
    }
end
