# Agent Guidelines for Dotfiles Repository

This is a personal dotfiles repository for Linux environments (ArchLinux and WSL/Ubuntu). It contains system and application configurations for a complete development environment.

## Repository Structure

```
~/.dotfiles/
├── config/          # Application configs (symlinked to ~/.config/)
├── home/            # Home directory files (symlinked to ~/)
├── local/           # Local binaries and scripts
├── container/       # Docker/Podman container definitions
├── service/         # Service configurations (proxy, etc.)
├── script/          # Utility scripts
├── boot/            # Boot loader configurations
└── etc/             # System-level configurations
```

## Build System and Commands

This repository uses **mise** (https://mise.jdx.dev/) as the primary task runner. All tasks are defined in `mise.toml`.

### Common Commands

```bash
# View all available tasks
mise tasks ls

# Install packages via system package manager (yay/apt/brew)
mise run install <package1> <package2> ...

# Create symbolic links
mise run link <source> [target]
mise run config <package> [config-dir]

# Configuration tasks
mise run config-dev          # Full development environment setup
mise run config-nvim         # Neovim configuration
mise run config-tmux         # Tmux configuration
mise run config-hypr         # Hyprland desktop environment
mise run config-git-user     # Configure git user info

# Container builds
mise run build-archlinux-container
mise run build-ubuntu-container

# Service management
mise run service-proxy up -d      # Start proxy service
mise run service-proxy logs -f    # View proxy logs
```

### Testing

This is a dotfiles repository without traditional unit tests. Validation is done through:
- Manual testing of configurations after deployment
- Running the actual tools/applications with the configs
- Service status checks: `systemctl --user status <service>`

## Code Style Guidelines

### General Formatting

- **Character encoding**: UTF-8
- **Line endings**: LF (Unix style)
- **Final newline**: Required
- **Max line length**: 150 characters (general), 160 for Lua

### Lua (Neovim Configuration)

**Formatting Rules** (enforced by `.stylua.toml`):
- **Indentation**: 4 spaces (no tabs)
- **Column width**: 160
- **Quote style**: Double quotes preferred
- **Call parentheses**: Always use parentheses for function calls
- **Requires sorting**: Enabled

**Style Conventions**:
```lua
-- Use descriptive snake_case for local variables/functions
local function surround()
    local config = require("nvim-surround.config")
    return config
end

-- Use explicit vim.opt for options
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Plugin configuration with lazy.nvim structure
return {
    {
        "plugin-name",
        event = "VeryLazy",
        keys = {
            { "<leader>x", "<cmd>Command<cr>", desc = "Description" },
        },
        opts = {
            -- Options here
        },
    },
}

-- Type annotations for clarity
---@type LazySpec[]
---@param paths string[]
---@return table<string, string>
```

**Import/Require Style**:
- Group requires at the top of functions or file
- Use local requires for performance
- Prefer lazy-loading for plugins

**Module Structure**:
```lua
local M = {}

function M.public_function()
    -- Implementation
end

return M
```

### Shell Scripts (Bash/Zsh)

**Formatting** (per `.editorconfig`):
- **Indentation**: Tabs
- **Tab size**: 4
- **Function style**: `function name() {` with opening brace on next line

**Style Conventions**:
```bash
#!/usr/bin/env bash
set -euo pipefail  # Strict error handling

# Use descriptive function names
function passwordgen() {
    echo $(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 13)
}

# Command existence checks
if (( $+commands[nvim] )); then
    alias vim="nvim"
fi

# Array handling
package_list=($usage_package)
for pkg in "${package_list[@]}"; do
    echo "$pkg"
done

# Conditional command checks
type -p command >/dev/null && echo "exists"
```

### Python

**Style Conventions**:
```python
# Type hints required for function signatures
from typing import list

def main(args: list[str]) -> str:
    """Docstrings for public functions."""
    result = process(args)
    return result

# Use decorators where appropriate
@result_handler(no_ui=True)
def handle_result(
    args: list[str],
    answer: str,
    target_window_id: int,
    boss: Boss
) -> None:
    """Implementation here."""
    pass
```

**Imports**:
- Standard library first
- Third-party libraries second
- Local imports last
- Use absolute imports

### Naming Conventions

- **Lua**: `snake_case` for functions/variables, `PascalCase` for classes/modules
- **Shell**: `lowercase_with_underscores` for functions, `UPPERCASE` for constants
- **Python**: `snake_case` for functions/variables, `PascalCase` for classes
- **Files**: `kebab-case` for config files, `snake_case` for scripts
- **Directories**: `lowercase` without separators where possible

### Configuration Files

**TOML** (mise.toml, stylua.toml, cargo configs):
- Use snake_case for keys
- Group related settings in sections
- Add descriptive comments for complex configurations

**YAML** (GitHub Actions, LazyGit, service configs):
- 2-space indentation
- Use explicit strings with quotes when needed
- Prefer block scalars for multi-line content

**JSON**:
- 2-space indentation
- No trailing commas
- Use double quotes for strings

## Error Handling

### Shell Scripts
```bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Check command existence before use
if ! type -p command >/dev/null; then
    echo "Error: command not found" >&2
    exit 1
fi

# Validate required parameters
if [ -z "${required_var:-}" ]; then
    echo "Error: required_var is not set" >&2
    exit 1
fi
```

### Lua
```lua
-- Use pcall for operations that may fail
local ok, result = pcall(require, "module")
if not ok then
    vim.notify("Failed to load module", vim.log.levels.ERROR)
    return
end

-- Validate inputs
if not path or path == "" then
    vim.notify("Invalid path", vim.log.levels.WARN)
    return
end
```

### Python
```python
# Use explicit exception handling
try:
    result = risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    raise
```

## Important Notes for Agents

1. **Symlink Management**: This repo uses symlinks extensively. Use `mise run link` and `mise run config` commands rather than manual symlinking.

2. **Package Installation**: Always use `mise run install <package>` which handles cross-platform differences (yay/apt/brew).

3. **Service Management**: System services are managed via systemd user units. Check status with `systemctl --user status <service>`.

4. **Neovim Plugins**: Managed by lazy.nvim. Plugin files are in `config/nvim/lua/plugins/*.lua`. Each file returns a table of plugin specs.

5. **Container Definitions**: Located in `container/archlinux/` and `container/ubuntu/`. Use mise tasks to build, not direct docker commands.

6. **No Tests to Run**: This is a configuration repository. "Testing" means deploying configs and verifying applications work correctly.

7. **Git Configuration**: Personal git user info must be set via `mise run config-git-user`, not committed to repo.
