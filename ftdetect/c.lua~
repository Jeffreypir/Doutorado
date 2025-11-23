
--[[==================== Configuration C ========================
--         Author:Jefferson Bezerra dos Santos
--]]--===========================================================

-- Configuração para carregar templates em arquivos *.c
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.c",
    callback = function()
        vim.bo.filetype = "c" -- Define o tipo de arquivo como 'c'
    end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.c",
    callback = function()
        -- Lê o conteúdo do template e insere no buffer
        vim.cmd("read $HOME/.config/nvim/after/template/template.c")
        -- Move o cursor para o início do arquivo e remove a linha em branco criada pelo 'read'
        vim.cmd("normal ggdd")
    end,
})

