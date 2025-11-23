local M = {}

-- caminhos centrais
local HOME = vim.env.HOME
local CENTRAL_JSON = HOME .. "/.config/nvim/after/fqbn/uno/compile_commands.json"
local CENTRAL_YAML = HOME .. "/.config/nvim/after/fqbn/uno/sketch.yaml"
local CENTRAL_MAKE = HOME .. "/.config/nvim/after/fqbn/uno/Makefile"

----------------------------------------------------------
-- Função: copiar compile_commands.json
----------------------------------------------------------
function M.compileJson()
    local buf_name = vim.api.nvim_buf_get_name(0)
    if buf_name == "" then return end

    local project_dir = vim.fn.fnamemodify(buf_name, ":p:h")
    local target_json = project_dir .. "/compile_commands.json"

    if vim.fn.filereadable(target_json) == 1 then
        return -- já existe
    end

    if vim.fn.filereadable(CENTRAL_JSON) == 1 then
        vim.fn.system(string.format('cp "%s" "%s"', CENTRAL_JSON, target_json))
        vim.notify("compile_commands.json copiado", vim.log.levels.INFO)
    else
        vim.notify("Arquivo central compile_commands.json não encontrado!", vim.log.levels.WARN)
    end
end

----------------------------------------------------------
-- Função: copiar sketch.yaml
----------------------------------------------------------
function M.sketchYaml()
    local buf_name = vim.api.nvim_buf_get_name(0)
    if buf_name == "" then return end

    local project_dir = vim.fn.fnamemodify(buf_name, ":p:h")
    local target_yaml = project_dir .. "/sketch.yaml"

    if vim.fn.filereadable(target_yaml) == 1 then
        return -- já existe
    end

    if vim.fn.filereadable(CENTRAL_YAML) == 1 then
        vim.fn.system(string.format('cp "%s" "%s"', CENTRAL_YAML, target_yaml))
        vim.notify("sketch.yaml copiado", vim.log.levels.INFO)
    else
        vim.notify("Arquivo central sketch.yaml não encontrado!", vim.log.levels.WARN)
    end
end

----------------------------------------------------------
-- Função: copiar Makefile
----------------------------------------------------------
function M.makefile()
    local buf_name = vim.api.nvim_buf_get_name(0)
    if buf_name == "" then return end

    local project_dir = vim.fn.fnamemodify(buf_name, ":p:h")
    local target_make = project_dir .. "/Makefile"

    if vim.fn.filereadable(target_make) == 1 then
        return -- já existe
    end

    if vim.fn.filereadable(CENTRAL_MAKE) == 1 then
        vim.fn.system(string.format('cp "%s" "%s"', CENTRAL_MAKE, target_make))
        vim.notify("Makefile copiado", vim.log.levels.INFO)
    else
        vim.notify("Arquivo central Makefile não encontrado!", vim.log.levels.WARN)
    end
end

return M

