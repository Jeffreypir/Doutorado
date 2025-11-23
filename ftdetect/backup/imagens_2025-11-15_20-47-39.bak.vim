vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.jpg", "*.jpeg", "*.png" },
    callback = function()
        vim.bo.filetype = "imagens"
    end,
})

