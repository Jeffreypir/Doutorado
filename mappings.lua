-- lua/config/mappings.lua 
-- Mapeamentos 

-- Importa módulos functions, utils e backup 
local funcs = require("config.functions")
local map_keys = require("config.utils").map_keys
local bak = require("config.backup")

-- Salvar o aquivo
map_keys("n", "<leader>w", ":w<CR>", { desc = "Salvar arquivo" })
map_keys("i", "fd", "<ESC>", { desc = "Sair do modo inserção" })

-----------------------------------------------------------------------
--- Mapeamentos do teclado 
--- Mapeamentos por modo
-----------------------------------------------------------------------
local keymaps = {
    n = { -- Normal Mode
        {"<F2>", funcs.run_file, { desc = "Executar arquivo atual" }},
        {"<F9>", funcs.fill_placeholders, { desc = "Preencher placeholders" }},
        {"<F10>", funcs.DefineSmart, { desc = "Define e variaveis" }},
        {"<leader>b", bak.create_backup, { desc = "Criar backup local" }},
        {"<leader>ne", ":Neotree<CR>", { desc = "Criar backup local" }},
        { "QQ", "<ESC>:q!<CR>", { desc = "Sair rápido" } },
        { "<A-h>", "<C-w>h", { desc = "Mover para janela à esquerda" } },
        { "<A-j>", "<C-w>j", { desc = "Mover para janela inferior" } },
        { "<A-k>", "<C-w>k", { desc = "Mover para janela superior" } },
        { "<A-l>", "<C-w>l", { desc = "Mover para janela à direita" } },
        { "T", ":terminal<CR>", { desc = "Abrir terminal" } },
        { "ct", ":split | resize 15 | terminal<CR>", { desc = "Terminal horizontal pequeno" } },
        { "<C-c>", '<ESC>:let@/=""<CR>', { desc = "Limpar highlight de busca" } },
        { "<C-a>", vim.lsp.buf.code_action, { desc = "Ações de código LSP" } },
        { "<A-t>", ":15split term://bash<CR>", { desc = "Abrir terminal 15 linhas" } },
        { "<A-z>", ":w<CR>", { desc = "Salvar arquivo" } },
        { "<leader>e", ":vsp | vertical resize 130 | terminal ranger<CR>", { desc = "Abrir Ranger lateral" } },
    },

    i = { -- Insert Mode
        { "<A-h>", "<C-\\><C-N><C-w>h", { desc = "Mover para janela à esquerda" } },
        { "<A-j>", "<C-\\><C-N><C-w>j", { desc = "Mover para janela inferior" } },
        { "<A-k>", "<C-\\><C-N><C-w>k", { desc = "Mover para janela superior" } },
        { "<A-l>", "<C-\\><C-N><C-w>l", { desc = "Mover para janela à direita" } },
        { "fd", "<ESC>", { desc = "Sair do modo de inserção" } },
        { "<leader>z", "<ESC>/<+.*+><CR>vf>xi", { desc = "Ir para próximo placeholder" } },
        { "<A-z>", "<ESC>:w<CR>a", { desc = "Salvar arquivo e continuar editando" } },
    },

    t = { -- Terminal Mode (
        { "<A-h>", [[<C-\><C-N><C-w>h]], { desc = "Mover para janela à esquerda" } },
        { "<A-j>", [[<C-\><C-N><C-w>j]], { desc = "Mover para janela inferior" } },
        { "<A-k>", [[<C-\><C-N><C-w>k]], { desc = "Mover para janela superior" } },
        { "<A-l>", [[<C-\><C-N><C-w>l]], { desc = "Mover para janela à direita" } },
        { "fdt", [[<C-\><C-n>]], { desc = "Sair do modo terminal" } },
    },
}

--------------------------------------------------------------------------------
-- Aplicação dos mapeamentos de forma automatizada
-- Este bloco percorre todos os modos (normal, inserção, terminal, etc.)
-- e aplica cada mapeamento definido na tabela `keymaps`.
--
-- Estrutura:
--   - O primeiro `for` percorre cada modo (`n`, `i`, `t`).
--   - O segundo `for` percorre cada atalho definido dentro daquele modo.
--   - A função `map_keys` é chamada para aplicar o atalho no Neovim.
--------------------------------------------------------------------------------
for mode, mappings in pairs(keymaps) do              -- Percorre os modos
    for _, map in ipairs(mappings) do                -- Percorre os atalhos dentro do modo atual
        -- map[1] → combinação de teclas (ex: "<A-h>")
        -- map[2] → ação/comando (ex: "<C-w>h")
        -- map[3] → opções adicionais (ex: { desc = "Mover janela à esquerda" })
        map_keys(mode, map[1], map[2], map[3])       -- Aplica o mapeamento
    end
end


--------------------------------------------------------------------------------
-- 📦 Keymaps personalizados para ações gerais (braço esquerdo)
-- Objetivo: atalhos para salvar, fechar, navegar buffers/splits/tabs, terminal
--------------------------------------------------------------------------------
local left_keymaps = {
    -- Arquivo e buffer
    { "n",    "WW", ":w<CR>", { desc = "Salvar arquivo" } },
    { "n", "<Leader>s", ":w<CR>", { desc = "Salvar arquivo" } },
    { "n", "<Leader>q", ":bd<CR>", { desc = "Fechar buffer atual" } },
    { "n", "<Leader>x", ":qa<CR>", { desc = "Fechar Neovim" } },
    { "n", "<Leader>n", ":bnext<CR>", { desc = "Próximo buffer" } },
    { "n", "<Leader>p", ":bprevious<CR>", { desc = "Buffer anterior" } },
    { "n", "<Leader>o", ":e ", { desc = "Abrir novo arquivo", silent = false } },
    { "n", "<Leader>r", ":e!<CR>", { desc = "Recarregar arquivo atual" } },

    -- Navegação entre splits
    { "n", "<Leader>h", "<C-w>h", { desc = "Mover para split à esquerda" } },
    { "n", "<Leader>j", "<C-w>j", { desc = "Mover para split abaixo" } },
    { "n", "<Leader>k", "<C-w>k", { desc = "Mover para split acima" } },
    { "n", "<Leader>l", "<C-w>l", { desc = "Mover para split à direita" } },
    { "n", "<Leader>c", ":close<CR>", { desc = "Fechar split atual" } },

    -- Navegação entre tabs
    { "n", "<Leader>t", ":tabnext<CR>", { desc = "Próxima tab" } },
    { "n", "<Leader>T", ":tabprevious<CR>", { desc = "Tab anterior" } },

    -- Terminal embutido
    { "n", "<Leader>tt", ":split | terminal<CR>", { desc = "Abrir terminal embutido" } },

    -- Pesquisa
    { "n", "<Leader>f", "/", { desc = "Pesquisar no arquivo atual", silent = false } },
}

--------------------------------------------------------------------------------
-- Aplicando os mapeamentos gerais
for _, map in ipairs(left_keymaps) do
    map_keys(map[1], map[2], map[3], map[4])
end


