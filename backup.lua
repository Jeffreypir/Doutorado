-- =======================================================================
-- 📦 Backup Local com Timestamp (comando :Backup)
-- Autor: Jefferson
-- Descrição:
--   - Cria pasta "backup" ao lado do arquivo (se não existir)
--   - Adiciona timestamp ao nome
--   - Executa backup manualmente com :Backup
--   - Mantém somente os 5 backups mais recentes
-- =======================================================================

local M = {}

-- 🕒 Gera timestamp: AAAA-MM-DD_HH-MM-SS
local function timestamp()
    return os.date("%Y-%m-%d_%H-%M-%S")
end

-- 🧹 Remove backups antigos (mantém só os 5 mais recentes)
local function clean_old_backups(dir, base)
    local cmd = string.format(
        "ls -t %s 2>/dev/null | grep '^%s' | tail -n +6",
        vim.fn.shellescape(dir),
        base
    )
    local handle = io.popen(cmd)
    if not handle then return end
    for file in handle:lines() do
        os.remove(dir .. "/" .. file)
    end
    handle:close()
end

-- 💾 Cria backup com timestamp dentro da subpasta /backup
function M.create_backup()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        vim.notify("❌ Nenhum arquivo aberto para backup.", vim.log.levels.ERROR)
        return
    end

    local dir = vim.fn.fnamemodify(file, ":h")
    local base = vim.fn.fnamemodify(file, ":t")
    local ext = base:match("(%.[^%.]+)$") or ""
    local name_no_ext = base:gsub("%.[^%.]+$", "")
    local backup_dir = dir .. "/backup"

    -- Cria pasta backup se não existir
    if vim.fn.isdirectory(backup_dir) == 0 then
        vim.fn.mkdir(backup_dir, "p")
    end

    local backup_name = string.format("%s_%s.bak%s", name_no_ext, timestamp(), ext)
    local backup_path = backup_dir .. "/" .. backup_name

    -- Cria o backup (usando copy nativo do SO)
    local ok = os.execute(string.format(
        "cp %s %s",
        vim.fn.shellescape(file),
        vim.fn.shellescape(backup_path)
    ))

    if ok then
        clean_old_backups(backup_dir, name_no_ext)
        vim.notify("💾 Backup criado em:\n" .. backup_path, vim.log.levels.INFO, { title = "Backup Local" })
    else
        vim.notify("❌ Erro ao criar backup!", vim.log.levels.ERROR)
    end
end

-- 🧩 Define o comando :Backup
vim.api.nvim_create_user_command("Backup", function()
    M.create_backup()
end, {})

return M

