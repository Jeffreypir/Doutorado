
--[[================ Configuration Latex ========================
--         Author:Jefferson Bezerra dos Santos
--]]--===========================================================

-- Configuração para carregar templates em arquivos *.c
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.tex",
    callback = function()
        vim.bo.filetype = "tex" -- Define o tipo de arquivo como 'tex'
    end,
})



