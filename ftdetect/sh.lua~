--[[==================== Configuration C ========================
--         Author:Jefferson Bezerra dos Santos
--]]--===========================================================

-- Configuração para carregar templates em arquivos *.c
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.sh",
    callback = function()
        vim.bo.filetype = "sh" -- Define o tipo de arquivo como 'sh'
    end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.sh",
    callback = function()
        -- Lê o conteúdo do template e insere no buffer
        vim.cmd("read $HOME/.config/nvim/after/template/template.sh")
        -- Move o cursor para o início do arquivo e remove a linha em branco criada pelo 'read'
        vim.cmd("normal ggdd")
    end,
})

