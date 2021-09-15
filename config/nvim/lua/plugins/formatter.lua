return function()
  require('formatter').setup({
    logging = false,
    filetype = {
      cpp = {
        -- clang-format
        function()
          return {
            exe = "clang-format",
            args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
            stdin = true,
            cwd = vim.fn.expand('%:p:h') -- Run clang-format in cwd of the file.
          }
        end
      },
      sh = {
        -- Shell Script Formatter
        function() return {exe = "shfmt", args = {"-i", 2}, stdin = true} end
      },
      javascript = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {
              "--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'
            },
            stdin = true
          }
        end
      },
      rust = {
        -- Rustfmt
        function()
          return {exe = "rustfmt", args = {"--emit=stdout"}, stdin = true}
        end
      },
      lua = {
        -- luafmt install from https://github.com/Koihik/LuaFormatter
        function()
          return
              {exe = "lua-format", args = {"--indent-width", 2}, stdin = true}
        end
      }
    }
  })
end
