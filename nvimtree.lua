-- lua/config/nvimtree.lua

-- Desativa o netrw completamente
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 32,
        side = "left",
        preserve_window_proportions = true,
    },
    renderer = {
        highlight_git = true,
        highlight_opened_files = "name",
        root_folder_modifier = ":t",
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                folder = {
                    arrow_closed = "",
                    arrow_open = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                },
            },
        },
    },
    filters = {
        dotfiles = false,
    },
    git = {
        enable = true,
    },
})

