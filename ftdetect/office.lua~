-- Detecta arquivos Office (docx, xlsx, pptx) antes do zip
vim.api.nvim_create_autocmd({"BufReadCmd"}, {
    pattern = { "*.docx", "*.xlsx", "*.pptx" },
    callback = function(args)
        -- Força ignorar o filetype zip
        vim.bo[args.buf].filetype = "office"
    end,
})

