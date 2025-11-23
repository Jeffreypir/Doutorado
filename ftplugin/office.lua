-- Abre documento do Office automaticamente via explorer.exe (WSL)
local filepath = vim.fn.expand("%:p")

-- Converte caminho Linux -> Windows
local winpath = vim.fn.systemlist("wslpath -w " .. vim.fn.shellescape(filepath))[1]

if winpath and winpath ~= "" then
    -- explorer.exe exige aspas no path
    local cmd = string.format('explorer.exe "%s"', winpath)

    -- Executa silenciosamente
    vim.cmd("silent execute " .. vim.fn.shellescape("!" .. cmd .. " &"))
end

