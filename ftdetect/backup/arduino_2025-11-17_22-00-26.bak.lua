-- Configuração para carregar templates e configurar o ambiente Arduino (Windows)

-- Defini o tipo de arquivo e carrega o tipo arduino
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.ino",
    callback = function(ev)
        vim.bo.filetype = "arduino"
        if ev.event == "BufNewFile" then
            vim.cmd("0read $HOME/.config/nvim/after/template/template.ino")
        end
    end,
})


local function AttachArduinoBoard()
    -- Executa o comando para listar as placas conectadas usando arduino-cli.exe
    local output = vim.fn.system('arduino-cli.exe board list')

    -- Obtém a linha que contém a porta e o FQBN
    local port_line = output:match("(COM%d+)")  -- Captura portas do Windows (COM3, COM4, etc.)
    local fqbn_line = output:match("(%S+:%S+:%S+)")  -- Captura o FQBN no formato esperado

    -- Verifica se a porta foi detectada
    local port = port_line or "COM3"         -- Define um valor padrão
    local fqbn = fqbn_line or "arduino:avr:uno"  -- Define um valor padrão

    -- Exibe mensagens de debug
    print("Porta detectada: " .. port)
    print("FQBN detectado: " .. fqbn)

    -- Monta o comando corretamente usando arduino-cli.exe
    local command = string.format("arduino-cli.exe board attach -p %s -b %s", port, fqbn)

    -- Executa o comando
    vim.cmd('!' .. command)
end

-- Mapeia o comando para anexar a placa Arduino ao criar um novo arquivo .ino
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.ino",
    callback = AttachArduinoBoard,
})

-- Compila o código e copia o arquivo compile_commands.json ao criar um novo arquivo .ino
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.ino",
    callback = function()
        -- Compila o código e copia o arquivo compile_commands.json usando arduino-cli.exe
        vim.cmd("silent !arduino-cli.exe compile --build-path ./build  && cp build/compile_commands.json . && rm -rf build/ .cache/ && fix_compile_commands")
    end,
})


-- Função para gerar .clangd automaticamente no WSL
local function GenerateClangd()
    local path = vim.fn.expand("%:p:h")  -- diretório do sketch atual
    local clangd_file = path .. "/.clangd"

    -- Se já existir, não sobrescreve
    if vim.fn.filereadable(clangd_file) == 1 then
        return
    end

    -- Detecta o nome do usuário do Windows via cmd.exe
    local handle = io.popen('cmd.exe /c "echo %USERNAME%"')
    local username = handle:read("*l") or "Public"
    handle:close()

    -- Remove possíveis caracteres de controle ou espaços extras
    username = username:gsub("%s+", "")

    -- Monta o caminho para as bibliotecas do Arduino
    local lib_root = "/mnt/c/Users/" .. username .. "/Documents/Arduino/libraries"

    -- Caminhos básicos do Arduino (ajuste se mudar versão)
    local flags = {
        "-include=/mnt/c/Users/" .. username .. "/AppData/Local/Arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/avr/include",
        "-isystem", "/mnt/c/Users/" .. username .. "/AppData/Local/Arduino15/packages/arduino/hardware/avr/1.8.6/cores/arduino",
        "-isystem", "/mnt/c/Users/" .. username .. "/AppData/Local/Arduino15/packages/arduino/hardware/avr/1.8.6/variants/standard"
    }

    -- Procura bibliotecas com cabeçalhos (.h)
    local p = io.popen('find "' .. lib_root .. '" -type f -name "*.h" -printf "%h\\n" | sort -u')
    if p then
        for line in p:lines() do
            table.insert(flags, "-isystem")
            table.insert(flags, line)
        end
        p:close()
    end

    -- Inclui o diretório do sketch
    table.insert(flags, "-I")
    table.insert(flags, ".")

    -- Monta o conteúdo do arquivo .clangd
    local clangd_content = "CompileFlags:\n  Add: [\n"
    for _, f in ipairs(flags) do
        clangd_content = clangd_content .. '    "' .. f .. '",\n'
    end
    clangd_content = clangd_content .. "  ]\n"

    -- Escreve o arquivo
    local f = io.open(clangd_file, "w")
    if f then
        f:write(clangd_content)
        f:close()
        print(".clangd criado em " .. path)
    else
        print("Falha ao criar .clangd! Verifique permissões.")
    end
end

-- Cria o .clangd automaticamente ao abrir um arquivo .ino
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.ino",
    callback = function()
        GenerateClangd()
    end
})

