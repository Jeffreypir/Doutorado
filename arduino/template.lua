local M = {}

function M.insert()
    vim.cmd("0read $HOME/.config/nvim/after/template/template.ino")
end

return M

