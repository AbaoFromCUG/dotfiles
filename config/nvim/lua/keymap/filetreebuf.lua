local api = require 'nvim-tree.api'
local which_key = require 'which-key'
local builtin = require 'telescope.builtin'
local file_templates = require 'file_templates'


local function get_available_path()
    local node = api.tree.get_node_under_cursor()
    assert(node, 'current cursor node is nil')
    if node.fs_stat.type ~= 'directory' then
        node = node.parent
    end
    return node.absolute_path
end

local create_template = function()
    file_templates.create(get_available_path())
end

local find_file = function()
    builtin.find_files {
        search_dirs = { get_available_path() },
    }
end
local find_word = function()
    builtin.live_grep {
        search_dirs = { get_available_path() },
    }
end

local desc = function(desc)
    return 'nvim-tree: ' .. desc
end

return function(bufno)
    which_key.register({
        -- ['<C-]>'] = { api.tree.change_root_to_node, opts 'CD' },
        -- ['<C-e>'] = { api.node.open.replace_tree_buffer, opts 'Open: In Place' },
        -- ['<C-k>'] = { api.node.show_info_popup, opts 'Info' },
        -- ['<C-r>'] = { api.fs.rename_sub, opts 'Rename: Omit Filename' },
        -- ['<C-t>'] = { api.node.open.tab, opts 'Open: New Tab' },
        -- ['<C-v>'] = { api.node.open.vertical, opts 'Open: Vertical Split' },
        -- ['<C-x>'] = { api.node.open.horizontal, opts 'Open: Horizontal Split' },
        -- ['<BS>'] = { api.node.navigate.parent_close, opts 'Close Directory' },
        ['<CR>'] = { api.node.open.edit, desc 'Open' },
        ['<Tab>'] = { api.node.open.preview, desc 'Open Preview' },
        ['>'] = { api.node.navigate.sibling.next, desc 'Next Sibling' },
        ['<'] = { api.node.navigate.sibling.prev, desc 'Previous Sibling' },
        ['.'] = { api.node.run.cmd, desc 'Run Command' },
        ['-'] = { api.tree.change_root_to_parent, desc 'Up' },
        ['a'] = { api.fs.create, desc 'Create' },
        ['bmv'] = { api.marks.bulk.move, desc 'Move Bookmarked' },
        ['B'] = { api.tree.toggle_no_buffer_filter, desc 'Toggle No Buffer' },
        ['c'] = { api.fs.copy.node, desc 'Copy' },
        ['C'] = { api.tree.toggle_git_clean_filter, desc 'Toggle Git Clean' },
        ['[c'] = { api.node.navigate.git.prev, desc 'Prev Git' },
        [']c'] = { api.node.navigate.git.next, desc 'Next Git' },
        ['d'] = { api.fs.remove, desc 'Delete' },
        ['D'] = { api.fs.trash, desc 'Trash' },
        ['E'] = { api.tree.expand_all, desc 'Expand All' },
        ['e'] = { api.fs.rename_basename, desc 'Rename: Basename' },
        [']e'] = { api.node.navigate.diagnostics.next, desc 'Next Diagnostic' },
        ['[e'] = { api.node.navigate.diagnostics.prev, desc 'Prev Diagnostic' },
        ['F'] = { api.live_filter.clear, desc 'Clean Filter' },
        ['f'] = { api.live_filter.start, desc 'Filter' },
        ['?'] = { api.tree.toggle_help, desc 'Help' },
        ['gy'] = { api.fs.copy.absolute_path, desc 'Copy Absolute Path' },
        ['H'] = { api.tree.toggle_hidden_filter, desc 'Toggle Dotfiles' },
        ['I'] = { api.tree.toggle_gitignore_filter, desc 'Toggle Git Ignore' },
        ['J'] = { api.node.navigate.sibling.last, desc 'Last Sibling' },
        ['K'] = { api.node.navigate.sibling.first, desc 'First Sibling' },
        ['m'] = { api.marks.toggle, desc 'Toggle Bookmark' },
        ['o'] = { api.node.open.edit, desc 'Open' },
        ['O'] = { api.node.open.no_window_picker, desc 'Open: No Window Picker' },
        ['p'] = { api.fs.paste, desc 'Paste' },
        ['P'] = { api.node.navigate.parent, desc 'Parent Directory' },
        ['q'] = { api.tree.close, desc 'Close' },
        ['r'] = { api.fs.rename, desc 'Rename' },
        ['R'] = { api.tree.reload, desc 'Refresh' },
        ['s'] = { api.node.run.system, desc 'Run System' },
        ['S'] = { api.tree.search_node, desc 'Search' },
        ['U'] = { api.tree.toggle_custom_filter, desc 'Toggle Hidden' },
        ['W'] = { api.tree.collapse_all, desc 'Collapse' },
        ['x'] = { api.fs.cut, desc 'Cut' },
        ['y'] = { api.fs.copy.filename, desc 'Copy Name' },
        ['Y'] = { api.fs.copy.relative_path, desc 'Copy Relative Path' },
        -- ['<2-LeftMouse>'] = { api.node.open.edit, opts 'Open' },
        -- ['<2-RightMouse>'] = { api.tree.change_root_to_node, opts 'CD' },
        ['A'] = { create_template, desc 'Create from Template' },
        ['<leader>'] = {
            f = {
                name = 'find',
                f = { find_file, desc 'find files' },
                w = { find_word, desc 'find word' },
            },
        }
    }, {
        buffer = bufno,
        silent = false,
    })
end
