-- lua/config/ui.lua


vim.cmd([[
  colorscheme lunaperche
]])

-- Ajuste de cores personalizado para funções
vim.api.nvim_set_hl(0, "Function", { fg = "#5AC8FA", bold = true })  -- azul-ciano

-- Destaca identificadores (variáveis, objetos, nomes de classes) em amarelo claro
vim.api.nvim_set_hl(0, "Identifier", { fg = "#FFD580", bold = true })

-- Comentários em cinza suave
vim.api.nvim_set_hl(0, "Comment", { fg = "#A9A9A9", italic = true })



