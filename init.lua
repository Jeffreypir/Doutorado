--[[
================================================================================
init.lua
================================================================================
Descrição:
Configurações personalizadas para o Neovim, otimizadas para produtividade
e manutenção. 
Autor: Jefferson Bezerra dos Santos
Data de Criação: 2023-10-10
Última Atualização: 2025-11-11
Licença: Livre para uso pessoal e educacional
================================================================================
]]

--=============================================================================
-- Ativa detecção de filetype, plugins e indent
vim.cmd([[filetype plugin indent on]])

-- Módulos utilizados:
-- ~/.config/nvim/after/lua/config
-- ~/.config/nvim/after/lua/

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
-- Submódulos: functions, utils e backup 
require("config.mappings")

-- Opções para o neovim  
require ("config.options")

-- Usando o lualine
require("config.lualine")

-- Netrw 
-- Padrão: Desativado
--require("config.netrw_conf")

-- Backup
require("config.backup")

-- Explorador de arquivos em lua
require("config.neotree")


