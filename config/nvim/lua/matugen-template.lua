local M = {}

function M.setup()
    require("base16-colorscheme").setup({
        base00 = "{{colors.background.default.hex}}",
        base01 = "{{colors.surface_container_lowest.default.hex}}",
        base02 = "{{colors.surface_container_low.default.hex}}",
        base03 = "{{colors.outline_variant.default.hex}}",
        base04 = "{{colors.on_surface_variant.default.hex}}",
        base05 = "{{colors.on_surface.default.hex}}",
        base06 = "{{colors.inverse_on_surface.default.hex}}",
        base07 = "{{colors.surface_bright.default.hex}}",
        base08 = "{{colors.tertiary.default.hex | lighten: -5}}",
        base09 = "{{colors.tertiary.default.hex}}",
        base0A = "{{colors.secondary.default.hex}}",
        base0B = "{{colors.primary.default.hex}}",
        base0C = "{{colors.tertiary_container.default.hex}}",
        base0D = "{{colors.primary_container.default.hex}}",
        base0E = "{{colors.secondary_container.default.hex}}",
        base0F = "{{colors.secondary.default.hex | lighten: -10}}",

        -- -- Background tones
        -- base00 = "{{colors.surface.default.hex}}",                -- Default Background
        -- base01 = "{{colors.surface_container.default.hex}}",      -- Lighter Background (status bars)
        -- base02 = "{{colors.surface_container_high.default.hex}}", -- Selection Background
        -- base03 = "{{colors.outline.default.hex}}",                -- Comments, Invisibles
        -- -- Foreground tones
        -- base04 = "{{colors.on_surface_variant.default.hex}}",     -- Dark Foreground (status bars)
        -- base05 = "{{colors.on_surface.default.hex}}",             -- Default Foreground
        -- base06 = "{{colors.on_surface.default.hex}}",             -- Light Foreground
        -- base07 = "{{colors.on_background.default.hex}}",          -- Lightest Foreground
        -- -- Accent colors
        -- base08 = "{{colors.error.default.hex}}",                  -- Variables, XML Tags, Errors
        -- base09 = "{{colors.tertiary.default.hex}}",               -- Integers, Constants
        -- base0A = "{{colors.secondary.default.hex}}",              -- Classes, Search Background
        -- base0B = "{{colors.primary.default.hex}}",                -- Strings, Diff Inserted
        -- base0C = "{{colors.tertiary_fixed_dim.default.hex}}",     -- Regex, Escape Chars
        -- base0D = "{{colors.primary_fixed_dim.default.hex}}",      -- Functions, Methods
        -- base0E = "{{colors.secondary_fixed_dim.default.hex}}",    -- Keywords, Storage
        -- base0F = "{{colors.error_container.default.hex}}",        -- Deprecated, Embedded Tags
    })
end

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
signal:start(
    "sigusr1",
    vim.schedule_wrap(function()
        package.loaded["matugen"] = nil
        require("matugen").setup()
    end)
)

return M
