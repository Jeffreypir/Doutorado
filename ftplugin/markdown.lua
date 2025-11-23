---===========================================================
-- FUNÇÕES DE MANIPULAÇÃO DE ARQUIVO
---===========================================================
-- Remove todos os comentários do tipo <!-- tmf: ... --> no buffer atual
local function remove_tmf_comment_lines()
    local pattern = "<!%-%-.-tmf:.-%-%->"
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local cleaned_lines = {}

    for _, line in ipairs(lines) do
        if not line:match(pattern) then
            table.insert(cleaned_lines, line)
        end
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, cleaned_lines)
end

vim.keymap.set("n", "<F9>", remove_tmf_comment_lines, { desc = "Remove linhas com <!-- tmf: ... -->" })

------------------=============================================
-- CONFIGURAÇÃO DE NAVEGAÇÃO EM TABELAS MARKDOWN
-- =============================================

-- Navegação básica entre células
vim.keymap.set('n', '<C-l>', 'f|l', { desc = 'Próxima célula (Markdown table)' })
vim.keymap.set('n', '<C-h>', 'F|h', { desc = 'Célula anterior (Markdown table)' })
vim.keymap.set('n', '<C-k>', 'k^f|', { desc = 'Célula acima (Markdown table)' })
vim.keymap.set('n', '<C-j>', 'j^f|', { desc = 'Célula abaixo (Markdown table)' })

-- Navegação no modo Insert
vim.keymap.set('i', '<C-l>', '<Esc>f|la', { desc = 'Próxima célula (Insert mode)' })
vim.keymap.set('i', '<C-h>', '<Esc>F|ha', { desc = 'Célula anterior (Insert mode)' })
vim.keymap.set('i', '<C-k>', '<Esc>k^f|a', { desc = 'Célula acima (Insert mode)' })
vim.keymap.set('i', '<C-j>', '<Esc>j^f|a', { desc = 'Célula abaixo (Insert mode)' })

-- =============================================
-- CONFIGURAÇÃO DO VIM-TABLE-MODE
-- =============================================

-- Configurações básicas do plugin
vim.g.table_mode_corner = '|'
vim.g.table_mode_fillchar = '-'
vim.g.table_mode_align_char = ':'

-- Ativação de fórmulas matemáticas
vim.g.table_mode_math_formula = 1
vim.g.table_mode_math_notation = 1  -- Permite notação A1/B2
vim.g.table_mode_math_map = 1
vim.g.table_mode_map_cr = 1

-- Atalhos mais intuitivos para fórmulas
vim.keymap.set('n', '<leader>tr', ':TableModeRecalculate<CR>', { noremap = true, silent = true, desc = 'Recalcular fórmulas na tabela' })
vim.keymap.set('n', '<leader>tf', ':TableAddFormula<CR>', { noremap = true, silent = true, desc = 'Adicionar fórmula à célula' })
vim.keymap.set('n', '<leader>te', ':TableEvalFormulaLine<CR>', { noremap = true, silent = true, desc = 'Avaliar fórmula na linha' })

-- Versões para modo insert
vim.keymap.set('i', '<leader>tr', '<ESC>:TableModeRecalculate<CR>a', { noremap = true, silent = true })
vim.keymap.set('i', '<leader>tf', '<ESC>:TableAddFormula<CR>a', { noremap = true, silent = true })
vim.keymap.set('i', '<leader>te', '<ESC>:TableEvalFormulaLine<CR>a', { noremap = true, silent = true })

-- =============================================
-- FUNÇÕES ÚTEIS PARA TABELAS
-- =============================================

-- Alinhar tabela automaticamente
vim.keymap.set('n', '<leader>ta', ':TableModeRealign<CR>', { desc = 'Alinhar tabela' })

-- Converter CSV para tabela Markdown
vim.keymap.set('n', '<leader>tc', ':%!mlr --icsv --ifs "," --opprint --barred --left then cat<CR>', { desc = 'Converter CSV para Markdown' })

-- Alternar modo tabela
vim.keymap.set('n', '<leader>tm', ':TableModeToggle<CR>', { desc = 'Alternar modo tabela' })

vim.keymap.set('i', '<Leader><CR>', ':<Plug>(table-mode-enter)', {})

function ReplaceNF()
    local word = vim.fn.expand("<cword>")
    if word ~= "NF" then
        print("Cursor não está em cima de 'NF'")
        return
    end

    -- Pergunta o valor
    local input = vim.fn.input("Valor para substituir NF: ")

    if input == nil or input == "" then
        print("Cancelado.")
        return
    end

    -- Substitui a palavra inteira no local
    vim.cmd("normal ciw" .. input)
end

-- Cria um comando :ReplaceNF
vim.api.nvim_create_user_command("ReplaceNF", ReplaceNF, {})


function ReplaceNF()
    local word = vim.fn.expand("<cword>")
    if word ~= "NF" then
        print("Cursor não está em cima de 'NF'")
        return
    end

    -- Pergunta o valor
    local input = vim.fn.input("Valor para substituir NF: ")

    if input == nil or input == "" then
        print("Cancelado.")
        return
    end

    -- Substitui a palavra inteira no local
    vim.cmd("normal ciw" .. input)
end

-- Cria um comando :ReplaceNF
vim.api.nvim_create_user_command("ReplaceNF", ReplaceNF, {})


-- Substitui NF 
vim.keymap.set("n", "<leader>nf", ReplaceNF, { desc = "Substitui NF perguntando valor" })



