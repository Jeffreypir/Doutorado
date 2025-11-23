-- Abre imagem pelo qimgv.exe no WSL automaticamente
local filepath = vim.fn.expand("%:p")

-- Converte caminho Linux -> Windows (WSL)
local winpath = vim.fn.systemlist("wslpath -w " .. vim.fn.shellescape(filepath))[1]

if winpath and winpath ~= "" then
    -- Monta o comando completo
    local cmd = string.format('!qimgv.exe "%s" &>/dev/null &', winpath)

    -- Executa silenciosamente
    vim.cmd("silent execute " .. vim.fn.shellescape(cmd))

end

