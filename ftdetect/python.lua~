--[[==================== Configuration Python ===================
--         Author:Jefferson Bezerra dos Santos
--]]--===========================================================

-- Configuração para carregar templates em arquivos *.c
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.py",
    callback = function()
        vim.bo.filetype = "python" -- Define o tipo de arquivo como 'Python'
    end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.py",
    callback = function()
        -- Lê o conteúdo do template e insere no buffer
        vim.cmd("read $HOME/.config/nvim/after/template/template.py")
        -- Move o cursor para o início do arquivo e remove a linha em branco criada pelo 'read'
        vim.cmd("normal ggdd")
    end,
})

