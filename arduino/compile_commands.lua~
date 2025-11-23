local M = {}

----------------------------------------------------------
-- Copia um arquivo de um diretório para a pasta do buffer atual
----------------------------------------------------------
function M.copyFile(src_dir, filename)
    local buf_name = vim.api.nvim_buf_get_name(0)
    if buf_name == "" then
        vim.notify("Nenhum arquivo aberto no buffer!", vim.log.levels.WARN)
        return
    end

    local project_dir = vim.fn.fnamemodify(buf_name, ":p:h")
    local dst = project_dir .. "/" .. filename

    if vim.fn.filereadable(dst) == 1 then
        vim.notify(filename .. " já existe no projeto.", vim.log.levels.INFO)
        return
    end

    local src = src_dir .. "/" .. filename

    if vim.fn.filereadable(src) ~= 1 then
        vim.notify("Arquivo não encontrado na origem: " .. src, vim.log.levels.ERROR)
        return
    end

    vim.fn.system(string.format('cp "%s" "%s"', src, dst))

    if vim.fn.filereadable(dst) == 1 then
        vim.notify(filename .. " copiado para o projeto!", vim.log.levels.INFO)
    else
        vim.notify("Falha ao copiar " .. filename, vim.log.levels.ERROR)
    end
end

function M.copyAll(files, src_dir)
    if not files or type(files) ~= "table" then
        vim.notify("copyAll: 'files' deve ser uma tabela", vim.log.levels.ERROR)
        return
    end

    if not src_dir or type(src_dir) ~= "string" then
        vim.notify("copyAll: 'src_dir' deve ser um caminho", vim.log.levels.ERROR)
        return
    end

    for _, filename in ipairs(files) do
        M.copyFile(src_dir, filename)
    end
end


return M

