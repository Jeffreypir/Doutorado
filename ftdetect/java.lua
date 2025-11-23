--[[==================== Configuration Java =====================
--         Author:Jefferson Bezerra dos Santos
--]]--===========================================================

-- Configuração para carregar templates em arquivos *.c
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.java",
    callback = function()
        vim.bo.filetype = "java" -- Define o tipo de arquivo como 'Python'
    end,
})


