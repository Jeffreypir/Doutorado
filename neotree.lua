-- Desativa o netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Configuração principal do Neo-tree
require("neo-tree").setup({
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,

    default_component_configs = {
        indent = { padding = 0 },
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            default = "",
            highlight = "NeoTreeFileIcon",
        },
        name = {
            trailing_slash = true,
            use_git_status_colors = true,
        },
        git_status = {
            symbols = {
                added = "✚",
                modified = "",
                deleted = "✖",
                renamed = "",
                untracked = "★",
                ignored = "◌",
                unstaged = "✗",
                staged = "✓",
                conflict = "",
            },
        },
    },

    filesystem = {
        bind_to_cwd = true, -- Sincroniza o Neo-tree com o :pwd
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,

        filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
        },

        window = {
            --position = "current",  --  modo estilo Netrw
            mappings = {
                ["<CR>"] = "open",          -- Enter abre o arquivo
                ["<BS>"] = "navigate_up", -- Sobe um nível
                ["l"] = function(state)     -- Entra na pasta e define como raiz
                    local node = state.tree:get_node()
                    if node.type == "directory" then
                        require("neo-tree.sources.filesystem").navigate(state, node:get_id())
                    else
                        require("neo-tree.sources.filesystem.commands").open(state)
                    end
                end,
                ["."] = "set_root",       -- Define nova raiz
                ["H"] = function(state)   -- Voltar para o diretório anterior
                    local fs = require("neo-tree.sources.filesystem")
                    local fs_commands = require("neo-tree.sources.filesystem.commands")

                    local current_root = state.path
                    local parent = vim.fn.fnamemodify(current_root, ":h")

                    if parent and vim.fn.isdirectory(parent) == 1 then
                        fs_commands.set_root(state, parent)
                        vim.cmd("cd " .. parent)
                        print("📁 Voltou para: " .. parent)
                    else
                        print("❌ Não foi possível voltar.")
                    end
                end,
            },
        },
    },

    event_handlers = {
        {
            event = "neo_tree_buffer_enter",
            handler = function()
                vim.cmd("setlocal number norelativenumber")
            end,
        },
    },


    buffers = {
        follow_current_file = { enabled = true },
        group_empty_dirs = true,
    },

    git_status = {
        window = { position = "float" },
    },
})

---------------------------------------------------------------------------
-- 🔁 Atualiza o `pwd` quando muda a raiz no Neo-tree
---------------------------------------------------------------------------
local events = require("neo-tree.events")

events.subscribe({
    event = events.NEO_TREE_WINDOW_AFTER_OPEN,
    handler = function()
        local sources = require("neo-tree.sources.manager")
        local fs_state = sources.get_state("filesystem")
        if not fs_state or not fs_state.path then return end
        vim.cmd("cd " .. fs_state.path)
    end,
})

