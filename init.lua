--[[
================================================================================
init.lua
================================================================================
Descrição:
Configurações personalizadas para o Neovim, otimizadas para produtividade
e manutenção. 
Autor: Jefferson Bezerra dos Santos
Data de Criação: 2023-10-10
Última Atualização: 2025-11-02
Licença: Livre para uso pessoal e educacional
================================================================================
]]

--=============================================================================

-- Ativa detecção de filetype, plugins e indent
vim.cmd([[filetype plugin indent on]])

-- Carrega plugins
require("plugins")

-- Configurações de interface e tema
require("config.ui")

-- Configuração do Treesitter
require("config.treesitter")

-- Configuração do nvim-cmp
require("config.cmp")

-- Configuração dos servidores LSP
require("config.lsp")

-- Mapeamentos
require("config.mappings")

-- Opções para o neovim  
require ("config.options")

-- Usando o lualine
require("config.lualine")

-- Netrw 
--require("config.netrw_conf")

-- nvim-tree
require("config.nvimtree")


-- Importa módulo de funções e utils
local funcs = require("config.functions")
local map_keys = require("config.utils").map_keys

-- Atalhos para as funções personalizadas
map_keys("n", "<F2>", funcs.run_file, { desc = "Executar arquivo atual" })
map_keys("n", "<F9>", funcs.fill_placeholders, { desc = "Preencher placeholders" })
map_keys("n", "<F10>", funcs.DefineSmart, { desc = "Define e variaveis" })




