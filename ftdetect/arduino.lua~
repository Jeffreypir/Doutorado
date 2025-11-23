vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.ino",
    callback = function()
        vim.bo.filetype = "arduino"
    end,
})

