
--[[==================== Arduino = ==============================
--]]--===========================================================
--
-- Autocomandos de inicialização do *ino
require("arduino.autocmds").setup() 

local map_keys = require("config.utils").map_keys
local luasnip = require("luasnip")

-- Namespace para funções Arduino
Arduino = {}

-- Função para converter caminho WSL → Windows
local function WSLtoWinPath(path)
    if path:match("^%a:\\") then
        return path
    end
    local drive, rest = path:match("^/mnt/(%a)/(.*)")
    if drive and rest then
        rest = rest:gsub("/", "\\")
        return drive:upper() .. ":\\" .. rest
    else
        return path
    end
end

-- Função para ler fqbn e port do sketch.yaml
local function ReadSketchConfig()
    local filename = "sketch.yaml"
    local file = io.open(filename, "r")
    if not file then
        print("Arquivo sketch.yaml não encontrado.")
        return nil, nil
    end

    local fqbn, port
    for line in file:lines() do
        fqbn = fqbn or line:match("fqbn:%s*(%S+)")
        port = port or line:match("port:%s*(%S+)")
    end
    file:close()

    if not fqbn or not port then
        print("Erro: fqbn ou port não encontrados no sketch.yaml.")
    end
    return fqbn, port
end

-- ================================================
-- Função para executar/compilar o sketch Arduino
-- ================================================
function Arduino.Run()
    local fqbn, port = ReadSketchConfig()
    if not fqbn or not port then return end

    local filename = vim.fn.expand('%:p')
    local win_path = WSLtoWinPath(filename)

    -- Remove o uso do cmd.exe e executa diretamente o arduino-cli.exe
    local command = 'arduino-cli.exe compile --upload --fqbn ' .. fqbn .. ' -p ' .. port .. ' "' .. win_path .. '"'

    print("🔧 Enviando para " .. port .. " com fqbn " .. fqbn)
    vim.cmd('split | resize 15 | terminal ' .. command)
end


-- =======================
-- Função run_file para outros tipos de arquivo + Arduino via sketch.yaml
-- =======================
function run_file()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand('%:p')
    local filename_no_ext = vim.fn.expand('%:r')

    local commands = {
        arduino = function()
            local fqbn, port = ReadSketchConfig()
            if not fqbn then
                print("⚠️ Não foi possível ler fqbn do sketch.yaml")
                return nil
            end
            local filename = vim.fn.expand("%:p")
            local win_path = filename:gsub("^/mnt/(%a)/", "%1:/"):gsub("/", "\\")
            return 'arduino-cli.exe compile --fqbn ' .. fqbn .. ' "' .. win_path .. '"'
        end,
    }


    local command = commands[filetype]
    if type(command) == 'function' then
        command = command()
    end

    if command then
        vim.cmd('split | resize 15 | terminal ' .. command)
    else
        print('Tipo de arquivo não suportado ou comando inválido: ' .. filetype)
    end
end

-- ==========================================================
-- Atualiza apenas default_port e adiciona default_fqbn se não existir
-- ==========================================================
local function UpdateSketchConfig()
    local yaml_file = "sketch.yaml"

    -- Executa o comando arduino-cli board list
    local handle = io.popen("arduino-cli.exe board list")
    if not handle then
        vim.notify("❌ Erro ao executar arduino-cli.exe board list", vim.log.levels.ERROR)
        return
    end

    local output = handle:read("*a")
    handle:close()

    -- Detecta porta (ex: COM6)
    local port = output:match("(COM%d+)") or "COM3"

    -- FQBN padrão (só usado caso NÃO exista no arquivo)
    local default_fqbn_value = "arduino:avr:uno"

    -- Lê conteúdo existente (para preservar tudo)
    local old_lines = {}
    if vim.fn.filereadable(yaml_file) == 1 then
        for line in io.lines(yaml_file) do
            table.insert(old_lines, line)
        end
    end

    local new_lines = {}
    local port_written = false
    local fqbn_exists = false

    for _, line in ipairs(old_lines) do

        -- Detecta se já existe default_fqbn (não altera!)
        if line:match("^default_fqbn:") then
            fqbn_exists = true
        end

        -- Atualiza apenas default_port
        if line:match("^default_port:") then
            table.insert(new_lines, "default_port: " .. port)
            port_written = true
        else
            table.insert(new_lines, line)
        end
    end

    -- Se não existir default_fqbn no arquivo → adiciona padrão
    if not fqbn_exists then
        table.insert(new_lines, "default_fqbn: " .. default_fqbn_value)
    end

    -- Se não existir default_port → adiciona
    if not port_written then
        table.insert(new_lines, "default_port: " .. port)
    end

    -- Escreve resultado
    local file = io.open(yaml_file, "w")
    if not file then
        vim.notify("❌ Erro ao abrir sketch.yaml para escrita.", vim.log.levels.ERROR)
        return
    end

    for _, line in ipairs(new_lines) do
        file:write(line .. "\n")
    end
    file:close()

    vim.notify("🔧 sketch.yaml atualizado!\nPORT: " .. port ..
        (fqbn_exists and "\nFQBN preservado" or "\nFQBN padrão adicionado"))
end

-- ==========================================================
-- Atualiza BOARD, PORT, BAUD e SKETCH no Makefile
-- Mantém tudo que não for essas linhas. Não quebra nada.
-- Estilo igual ao UpdateSketchConfig que funciona.
-- ==========================================================
local function UpdateMakefile()
    local makefile = "Makefile"

    -- Nome do sketch = nome do arquivo .ino aberto
    local sketch_path = vim.api.nvim_buf_get_name(0)
    local sketch_name = vim.fn.fnamemodify(sketch_path, ":t")

    if sketch_name == "" or not sketch_name:match("%.ino$") then
        vim.notify("❌ Abra um arquivo .ino para atualizar o SKETCH", vim.log.levels.ERROR)
        return
    end

    -- Lê sketch.yaml para pegar BOARD, PORT e BAUD
    local yaml_file = "sketch.yaml"
    local board = nil
    local port = nil
    local baud = nil

    if vim.fn.filereadable(yaml_file) == 1 then
        for line in io.lines(yaml_file) do
            local key, value = line:match("^%s*([%w_]+)%s*:%s*(.+)%s*$")
            if key and value then
                if key == "default_fqbn" then board = value end
                if key == "default_port" then port = value end
                if key == "baud" then baud = value end
            end
        end
    end

    -- Valores padrão se não existirem
    board = board or "arduino:avr:uno"
    port  = port  or "COM3"
    baud  = baud  or "9600"

    if vim.fn.filereadable(makefile) == 0 then
        vim.notify("❌ Makefile não encontrado", vim.log.levels.ERROR)
        return
    end

    -- Ler Makefile preservando tudo
    local old_lines = {}
    for line in io.lines(makefile) do
        table.insert(old_lines, line)
    end

    local new_lines = {}
    local found_board = false
    local found_port = false
    local found_sketch = false
    local found_baud = false

    for _, line in ipairs(old_lines) do
        local new_line = line

        if line:match("^BOARD%s*=") then
            new_line = "BOARD = " .. board
            found_board = true
        elseif line:match("^PORT%s*=") then
            new_line = "PORT = " .. port
            found_port = true
        elseif line:match("^SKETCH%s*=") then
            new_line = "SKETCH = " .. sketch_name
            found_sketch = true
        elseif line:match("^BAUD%s*=") then
            new_line = "BAUD = " .. baud
            found_baud = true
        end

        table.insert(new_lines, new_line)
    end

    -- Se faltarem variáveis → adiciona no final
    if not found_board then table.insert(new_lines, "BOARD = " .. board) end
    if not found_port  then table.insert(new_lines, "PORT = " .. port) end
    if not found_sketch then table.insert(new_lines, "SKETCH = " .. sketch_name) end
    if not found_baud then table.insert(new_lines, "BAUD = " .. baud) end

    -- Reescrever Makefile
    local file = io.open(makefile, "w")
    if not file then
        vim.notify("❌ Erro ao reescrever Makefile", vim.log.levels.ERROR)
        return
    end

    for _, l in ipairs(new_lines) do
        file:write(l .. "\n")
    end
    file:close()

    vim.notify("🔧 Makefile atualizado!\nBOARD=" .. board ..
        "\nPORT=" .. port ..
        "\nBAUD=" .. baud ..
        "\nSKETCH=" .. sketch_name)
end


-- 🛰️ Função para abrir monitor serial interativo
local function OpenArduinoMonitor()
    local yaml_file = "sketch.yaml"
    local baud = "9600"
    local port = nil
    local lines = {}

    -- Tenta ler o YAML se existir
    local file = io.open(yaml_file, "r")
    if file then
        for line in file:lines() do
            table.insert(lines, line)
            local k, v = line:match("^(%w+):%s*(%S+)")
            if k == "baud" then
                baud = v
            elseif k == "port" then
                port = v
            end
        end
        file:close()

        -- Verifica se já existe uma linha com "baud:"
        local has_baud = false
        for _, l in ipairs(lines) do
            if l:match("^baud:") then
                has_baud = true
                break
            end
        end

        -- Se não encontrou baud, adiciona no final do arquivo
        if not has_baud then
            local f = io.open(yaml_file, "a") -- append
            if f then
                f:write("baud: 9600\n")
                f:close()
                vim.notify("⚙️ Campo 'baud' não encontrado. Adicionado 'baud: 9600' no final do sketch.yaml")
            end
        end
    else
        vim.notify("⚠️ sketch.yaml não encontrado. Usando baud padrão: 9600", vim.log.levels.WARN)
    end

    -- Se a porta não estiver definida, tenta detectar automaticamente
    if not port then
        local handle = io.popen("arduino-cli.exe board list")
        if handle then
            local output = handle:read("*a")
            handle:close()
            port = output:match("(COM%d+)")
        end
    end

    if not port then
        vim.notify("❌ Nenhuma porta detectada. Conecte o Arduino e tente novamente.", vim.log.levels.ERROR)
        return
    end

    -- Comando para abrir o monitor serial
    local cmd = string.format("arduino-cli.exe monitor -p %s -c baudrate=%s", port, baud)
    vim.notify("🔌 Abrindo monitor serial em " .. port .. " (" .. baud .. " baud)")

    -- Abre o monitor em um split inferior de 15 linhas
    vim.cmd("split | resize 15 | terminal " .. cmd)
end


-- Função para criar ou atualizar o Makefile para Arduino
function CreateMakefile()
    local filename = vim.fn.expand("%:t")
    local fqbn, port = ReadSketchConfig()

    if not fqbn or not port then
        print("❌ Não foi possível obter fqbn ou port do sketch.yaml.")
        return
    end

    -- Verifica se já existe um Makefile e se ele contém uma linha de BAUD
    local has_baud = false
    local existing_baud_line = nil
    if vim.fn.filereadable("Makefile") == 1 then
        for line in io.lines("Makefile") do
            if line:match("^BAUD%s*=") then
                has_baud = true
                existing_baud_line = line
                break
            end
        end
    end

    -- Define o conteúdo base do Makefile
    local lines = {
        "# ==========================================================",
        "# Makefile para Arduino CLI",
        "# Gerado automaticamente por CreateMakefile()",
        "# ==========================================================",
        "",
        "ARDUINO_CLI = arduino-cli.exe",
        "BOARD = " .. fqbn,
        "PORT = " .. port,
        "SKETCH = " .. filename,
        "BUILD_DIR = build",
    }

    -- Só adiciona o baudrate se ele ainda não existir
    if has_baud then
        table.insert(lines, existing_baud_line)
    else
        table.insert(lines, "BAUD = 9600")
    end

    -- Continua o restante das regras
    local rest = {
        "",
        "compile:",
        "\t$(ARDUINO_CLI) compile --fqbn $(BOARD) $(SKETCH)",
        "",
        "upload:",
        "\t$(ARDUINO_CLI) upload -p $(PORT) --fqbn $(BOARD) $(SKETCH)",
        "",
        "usb: compile",
        "\t$(ARDUINO_CLI) upload --fqbn $(BOARD) --programmer usbasp $(SKETCH)",
        "",
        "clean:",
        "\trm -rf $(BUILD_DIR)",
        "",
        "monitor:",
        "\t$(ARDUINO_CLI) monitor -p $(PORT) -c baudrate=$(BAUD)",
        "",
        "run: compile upload",
    }

    for _, v in ipairs(rest) do
        table.insert(lines, v)
    end

    -- Gera o conteúdo final
    local makefile_content = table.concat(lines, "\n")

    local makefile_exists = vim.fn.filereadable("Makefile") == 1
    local file = io.open("Makefile", "w")
    if file then
        file:write(makefile_content)
        file:close()

        if makefile_exists then
            print("🔄 Makefile atualizado (baudrate preservado).")
        else
            print("✅ Makefile criado para " .. filename)
        end
    else
        print("❌ Erro ao criar ou atualizar o Makefile.")
    end
end


-- Função para compilar e fazer upload
function MakeAndRun()
    local result = vim.fn.system("make run")
    print(result) -- Mostra o output do make
    if vim.v.shell_error == 0 then
        print("Upload bem-sucedido para o Arduino.")
    else
        print("Erro no upload para o Arduino.")
    end
end

-- Função para compilar e fazer upload com programmer usbasp
function MakeAndUsb()
    local result = vim.fn.system("make usb")
    print(result) -- Mostra o output do make
    if vim.v.shell_error == 0 then
        print("Upload bem-sucedido para o Arduino usando programmer usbasp.")
    else
        print("Erro no upload para o Arduino.")
    end
end

-- ==========================================================
-- Mapeamentos de Teclas - Arduino e Execução
-- Descrição: Atalhos para automação de tarefas com Arduino CLI
-- ==========================================================

-- Executar o arquivo atual
map_keys("n", "<F2>", run_file, { desc = "Executar arquivo atual" })

-- Rodar Arduino.Yaml
map_keys("n", "<F3>", Arduino.Run, { desc = "Executar Arduino.Yaml" })

-- Abrir o monitor serial
map_keys("n", "<F4>", OpenArduinoMonitor, { desc = "Abrir monitor serial Arduino CLI" })

-- Atualizar sketch.yaml e recriar Makefile
-- map_keys("n", "<F5>", function() UpdateSketchConfig(); UpdateMakefile()
map_keys("n", "<F5>", function() UpdateSketchConfig() end, { desc = "Atualizar sketch.yaml" })

-- Compilar e executar Makefile
map_keys("n", "<F6>", MakeAndRun, { desc = "Compilar e executar Makefile" })

-- Compilar e enviar via USB
map_keys("n", "<F7>", MakeAndUsb, { desc = "Compilar e enviar via USB" })

-- Atualizar o Makefile 
map_keys("n", "<leader>m", function() UpdateMakefile() end, { desc = "Atualizar Makefile" })
vim.api.nvim_create_user_command("ArduinoUpdateMakefile", function()
    UpdateMakefile()
end, {})


-- Carrega o módulo LuaSnip para gerenciar snippets
local luasnip = require('luasnip')

-- Define snippets específicos para arquivos C, C++ e Arduino
local snippets = {
    -- Snippet para loop 'for'
    luasnip.snippet("for", {
        -- Início do loop 'for'
        luasnip.text_node("for (int "),
        -- Placeholder para o nome da variável do loop (padrão: 'numb')
        luasnip.insert_node(1, "numb"),
        luasnip.text_node(" = 0; "),

        -- Reutiliza o nome da variável do loop na inicialização
        luasnip.function_node(function(args)
            return args[1][1] or "numb"
        end, {1}),
        luasnip.text_node(" < "),

        -- Placeholder para o limite do loop (padrão: 'lim_max')
        luasnip.insert_node(2, "lim_max"),
        luasnip.text_node("; "),

        -- Reutiliza o nome da variável do loop no incremento
        luasnip.function_node(function(args)
            return args[1][1] or "numb"
        end, {1}),
        luasnip.text_node("++) {"),

        -- Quebra de linha e indentação do corpo do loop
        luasnip.text_node({ "", "\t" }),

        -- Placeholder para o conteúdo do loop
        luasnip.insert_node(0),

        -- Fechamento do loop 'for'
        luasnip.text_node({ "", "}" }),
    }),

    -- Snippet para loop 'while'
    luasnip.snippet("while", {
        -- Texto fixo: início do loop
        luasnip.text_node("while ("),
        -- Primeiro placeholder: condição do loop (padrão: 'condition')
        luasnip.insert_node(1, "condition"),
        -- Texto fixo: fechamento da condição e início do bloco
        luasnip.text_node(") {"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Segundo placeholder: corpo do loop
        luasnip.insert_node(0, "code_block"),
        -- Texto fixo: fechamento do loop
        luasnip.text_node({ "", "}" }),
    }),

    -- Snippet para condicional 'if-else'
    luasnip.snippet("if", {
        -- Texto fixo: início da condicional
        luasnip.text_node("if ("),
        -- Primeiro placeholder: condição (padrão: 'condition')
        luasnip.insert_node(1, "condition"),
        -- Texto fixo: início do bloco 'if'
        luasnip.text_node(") {"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        luasnip.insert_node(2, "code_block"),
        -- Texto fixo: fechamento do bloco 'else'
        luasnip.text_node({ "", "}" }),
    }),

    -- Snippet para condicional 'if-else'
    luasnip.snippet("ifelse", {
        -- Texto fixo: início da condicional
        luasnip.text_node("if ("),
        -- Primeiro placeholder: condição (padrão: 'condition')
        luasnip.insert_node(1, "condition"),
        -- Texto fixo: início do bloco 'if'
        luasnip.text_node(") {"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Segundo placeholder: bloco de código dentro do 'if'
        luasnip.insert_node(2),
        -- Texto fixo: início do bloco 'else'
        luasnip.text_node({ "", "} else {", "\t" }),
        -- Terceiro placeholder: bloco de código dentro do 'else'
        luasnip.insert_node(3),
        -- Texto fixo: fechamento do bloco 'else'
        luasnip.text_node({ "", "}" }),
    }),

    -- Snippet para 'printf'
    luasnip.snippet("pr", {
        -- Texto fixo: início do 'printf'
        luasnip.text_node('printf("'),
        -- Primeiro placeholder: mensagem (padrão: 'message')
        luasnip.insert_node(1, "message"),
        -- Texto fixo: quebra de linha e vírgula
        luasnip.text_node('\\n", '),
        -- Segundo placeholder: variável a ser impressa (padrão: 'variable')
        luasnip.insert_node(2, "variable"),
        -- Texto fixo: fechamento do 'printf'
        luasnip.text_node(");"),
    }),


    -- Snippet para criar função em C, C++ e Arduino
    luasnip.snippet("fun", {
        -- Comentário de cabeçalho da função
        luasnip.text_node({
            "/*=================== FUNCTION () ============================",
            " * Function: "
        }),
        luasnip.insert_node(1, "function_name"), -- Nome da função (primeiro placeholder)
        luasnip.text_node({ "", " * Description: " }),
        luasnip.insert_node(2, "Brief description of the function"), -- Descrição da função
        luasnip.text_node({
            "",
            " * ==========================================================",
            " */",
            "",
        }),

        -- Tipo de retorno da função (padrão: 'void')
        luasnip.insert_node(3, "void"),
        luasnip.text_node(" "), -- Espaço após o tipo de retorno
        luasnip.function_node(function(args) return args[1][1] end, {1}), -- Reutiliza o nome da função
        luasnip.text_node("("),
        -- Argumentos da função (padrão: 'int arg1, int arg2')
        luasnip.insert_node(4, "int arg1, int arg2"),
        luasnip.text_node({ ") {", "\t" }), -- Abertura do bloco da função

        -- Bloco de código dentro da função (placeholder padrão: "// Your code here")
        luasnip.insert_node(5, "// Your code here"),
        luasnip.text_node({ "", "}", "", "/*---------- End of function -----------------*/" }),
    }),

    -- 1. Snippet para estrutura básica de um sketch Arduino
    luasnip.snippet("sketch", {
        -- Texto fixo: início da função setup
        luasnip.text_node('void setup() {'),
        -- Primeiro placeholder: código de configuração (padrão: '// configuração inicial')
        luasnip.insert_node(1, "// configuração inicial"),
        -- Texto fixo: fechamento da função setup
        luasnip.text_node({ "", "}", "", "" }),
        -- Texto fixo: início da função loop
        luasnip.text_node('void loop() {'),
        -- Segundo placeholder: código principal (padrão: '// código principal')
        luasnip.insert_node(2, "// código principal"),
        -- Texto fixo: fechamento da função loop
        luasnip.text_node({ "", "}" }),
    }),

    -- 2. Snippet para configurar um pino como entrada ou saída
    luasnip.snippet("pinmode", {
        -- Texto fixo: início da função pinMode
        luasnip.text_node('pinMode('),
        -- Primeiro placeholder: número do pino (padrão: 'LED_BUILTIN')
        luasnip.insert_node(1, "LED_BUILTIN"),
        -- Texto fixo: vírgula e espaço
        luasnip.text_node(', '),
        -- Segundo placeholder: modo do pino (padrão: 'OUTPUT')
        luasnip.insert_node(2, "OUTPUT"),
        -- Texto fixo: fechamento da função
        luasnip.text_node(');'),
    }),

    -- 3. Snippet para ler um pino digital
    luasnip.snippet("dread", {
        -- Texto fixo: início da função digitalRead
        luasnip.text_node('digitalRead('),
        -- Primeiro placeholder: número do pino (padrão: '2')
        luasnip.insert_node(1, "2"),
        -- Texto fixo: fechamento da função
        luasnip.text_node(');'),
    }),

    -- 4. Snippet para escrever em um pino digital
    luasnip.snippet("dwrite", {
        -- Texto fixo: início da função digitalWrite
        luasnip.text_node('digitalWrite('),
        -- Primeiro placeholder: número do pino (padrão: 'LED_BUILTIN')
        luasnip.insert_node(1, "LED_BUILTIN"),
        -- Texto fixo: vírgula e espaço
        luasnip.text_node(', '),
        -- Segundo placeholder: valor (padrão: 'HIGH')
        luasnip.insert_node(2, "HIGH"),
        -- Texto fixo: fechamento da função
        luasnip.text_node(');'),
    }),

    -- 5. Snippet para ler um pino analógico
    luasnip.snippet("aread", {
        -- Texto fixo: início da função analogRead
        luasnip.text_node('analogRead('),
        -- Primeiro placeholder: número do pino (padrão: 'A0')
        luasnip.insert_node(1, "A0"),
        -- Texto fixo: fechamento da função
        luasnip.text_node(');'),
    }),

    -- 6. Snippet para escrever em um pino PWM
    luasnip.snippet("awrite", {
        -- Texto fixo: início da função analogWrite
        luasnip.text_node('analogWrite('),
        -- Primeiro placeholder: número do pino (padrão: '3')
        luasnip.insert_node(1, "3"),
        -- Texto fixo: vírgula e espaço
        luasnip.text_node(', '),
        -- Segundo placeholder: valor (padrão: '128')
        luasnip.insert_node(2, "128"),
        -- Texto fixo: fechamento da função
        luasnip.text_node(');'),
    }),

    -- 7. Snippet para delay
    luasnip.snippet("delay", {
        -- Texto fixo: início da função delay
        luasnip.text_node('delay('),
        -- Primeiro placeholder: tempo em milissegundos (padrão: '1000')
        luasnip.insert_node(1, "Time"),
        -- Texto fixo: fechamento da função
        luasnip.text_node(');'),
    }),

    -- 8. Snippet para Serial.begin
    luasnip.snippet("serial", {
        -- Texto fixo: início da função Serial.begin
        luasnip.text_node('Serial.begin('),
        -- Primeiro placeholder: taxa de transmissão (padrão: '9600')
        luasnip.insert_node(1, "9600"),
        -- Texto fixo: fechamento da função
        luasnip.text_node(');'),
    }),

    -- 9. Snippet para Serial.println
    luasnip.snippet("sprint", {
        -- Texto fixo: início da função Serial.println
        luasnip.text_node('Serial.println('),
        -- Primeiro placeholder: mensagem (padrão: '"Hello, Arduino!"')
        luasnip.insert_node(1, '"Hello, Arduino!"'),
        -- Texto fixo: fechamento da função
        luasnip.text_node(');'),
    }),

    -- 10. Snippet para estrutura de um botão
    luasnip.snippet("button", {
        -- Texto fixo: declaração do pino do botão
        luasnip.text_node('const int buttonPin = '),
        -- Primeiro placeholder: número do pino (padrão: '2')
        luasnip.insert_node(1, "2"),
        -- Texto fixo: fechamento da declaração
        luasnip.text_node({ ';', '', '' }),
        -- Texto fixo: configuração do pino do botão
        luasnip.text_node('pinMode(buttonPin, INPUT);'),
        -- Texto fixo: leitura do botão
        luasnip.text_node({ '', 'int buttonState = digitalRead(buttonPin);', '' }),
        -- Texto fixo: condição para verificar o estado do botão
        luasnip.text_node('if (buttonState == HIGH) {'),
        -- Segundo placeholder: ação ao pressionar o botão (padrão: '// ação')
        luasnip.insert_node(2, "// ação"),
        -- Texto fixo: fechamento da condição
        luasnip.text_node({ "", "}" }),
    }),

}

-- Adiciona os snippets ao LuaSnip para o tipo de arquivo Arduino
luasnip.add_snippets('arduino', snippets)


-- Avança para o próximo placeholder (tanto no modo de inserção quanto de seleção)
map_keys({ "i", "s" }, "<Tab>", function()
    if luasnip.jumpable(1) then
        luasnip.jump(1)
    end
end, { desc = "Ir para o próximo placeholder do snippet" })

-- Volta para o placeholder anterior (Alt+Tab)
map_keys({ "i", "s" }, "<A-Tab>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { desc = "Voltar para o placeholder anterior" })

