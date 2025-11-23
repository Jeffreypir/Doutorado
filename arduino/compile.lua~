local M = {}

function M.run()
    -- Gera apenas compile_commands.json na pasta atual
    local cmd = table.concat({
        "arduino-cli.exe compile --only-compilation-database",
        "--fqbn arduino:avr:uno",   -- altere para sua placa
        "--build-path ./build"       -- gera o compile_commands.json em build/
    }, " ")

    -- executa o comando e descarta a saída
    vim.fn.system(cmd .. " >/dev/null 2>&1")

    -- copia o compile_commands.json para a pasta atual
    vim.fn.system("cp ./build/compile_commands.json ./ >/dev/null 2>&1")

    -- remove a pasta build e .cache
    vim.fn.system("rm -rf ./build/ .cache/ >/dev/null 2>&1")

    -- opcional: ajusta compile_commands se você tiver fix_compile_commands
    vim.fn.system("fix_compile_commands >/dev/null 2>&1")
end

return M

