--[[==================== Configuration R ========================
--         Author:Jefferson Bezerra dos Santos
--]]--===========================================================

-- Configuração para carregar templates em arquivos *.c
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.r, *R",
    callback = function()
        vim.bo.filetype = "r" -- Define o tipo de arquivo como 'Python'
    end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.r, *R",
    callback = function()
        -- Lê o conteúdo do template e insere no buffer
        vim.cmd("read $HOME/.config/nvim/after/template/template.r")
        -- Move o cursor para o início do arquivo e remove a linha em branco criada pelo 'read'
        vim.cmd("normal ggdd")
    end,
})

