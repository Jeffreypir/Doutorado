--[[===================== Bash  =================================
             Author:Jefferson Bezerra dos Santos
--]]--===========================================================

-- Configuração do Bash
-- Função para mapear teclas de forma simplificada
-- Modo: 'n' (normal), 'i' (inserção), 'v' (visual), 't' (terminal)
-- Tecla: A combinação de teclas a ser mapeada
-- Ação: O comando ou função a ser executada
-- Opções: Tabela de opções (noremap, silent, etc.)
--]]
--
-- Função para mapear teclas de forma simplificada
local function map_keys(mode, keys, action, opts)
    opts = opts or {}
    opts.noremap = opts.noremap == nil and true or opts.noremap -- Ativa noremap por padrão
    opts.silent = opts.silent == nil and true or opts.silent -- Ativa silent por padrão
    vim.api.nvim_set_keymap(mode, keys, action, opts)
end

-- Atalhos para inserir pares de caracteres no modo de inserção

-- Inserir {} e posicionar o cursor entre as chaves
map_keys('i', '{', '{}<ESC>i')

-- Inserir [] e posicionar o cursor entre os colchetes
map_keys('i', '[', '[]<ESC>i')

-- Inserir () e posicionar o cursor entre os parênteses
map_keys('i', '(', '()<ESC>i')

-- Inserir "" e posicionar o cursor entre as aspas
map_keys('i', '"', '""<ESC>i')

-- Inserir '' e posicionar o cursor entre as aspas simples
map_keys('i', "'", "''<ESC>i")


-- Mapeamentos para o modo normal
map_keys('n', '<F3>', ':!chmod +x % <CR> ') -- Abrir o explorador de arquivos

