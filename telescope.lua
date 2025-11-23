-----------------------------------------------------------------------
-- Módulo de configuração do Telescope
-----------------------------------------------------------------------

local M = {}

function M.setup()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local map_keys = require("config.utils").map_keys

    -------------------------------------------------------------------
    -- Configuração do Telescope
    -------------------------------------------------------------------
    telescope.setup({
        defaults = {
            prompt_prefix = "   ",
            selection_caret = "➤ ",
            path_display = { "smart" },
        },
    })

    -------------------------------------------------------------------
    -- Atalhos usando sua arquitetura atual
    -------------------------------------------------------------------
    local keymaps = {
        n = { -- Normal mode
            {"<leader>ff", builtin.find_files, { desc = "Procurar arquivos" }},
            {"<leader>fg", builtin.live_grep,  { desc = "Buscar texto (Grep)" }},
            {"<leader>fb", builtin.buffers,    { desc = "Listar buffers" }},
            {"<leader>fh", builtin.help_tags,  { desc = "Ajuda do Neovim" }},
            {"<leader>fo", builtin.oldfiles,   { desc = "Arquivos recentes" }},
        }
    }

    -- APLICA OS MAPEAMENTOS (este loop É obrigatório na sua arquitetura)
    for mode, mappings in pairs(keymaps) do
        for _, map in ipairs(mappings) do
            map_keys(mode, map[1], map[2], map[3])
        end
    end
end

return M

