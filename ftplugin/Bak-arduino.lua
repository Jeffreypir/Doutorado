
--[[==================== Arduino = ==============================
--]]--===========================================================


-- Tabela global para funções relacionadas ao Arduino
Arduino = {}

-- Função para detectar a placa e a porta, e fazer upload do código Arduino
function Arduino.Upload()
    -- Executa o comando para listar as placas conectadas
    local output = vim.fn.system('arduino-cli.exe board list')

    -- Obtém a linha que contém a porta e o FQBN
    local port = output:match("(/dev/tty%S+)")  -- Captura portas como /dev/ttyUSB0 ou /dev/ttyACM0
    local fqbn = output:match("(%S+:%S+:%S+)")  -- Captura o FQBN no formato esperado

    -- Verifica se a porta foi detectada
    if not port then
        port = "/dev/ttyACM0"  -- Define um valor padrão
        print("Placa não detectada. Usando porta padrão: " .. port)
    end

    -- Verifica se o FQBN foi detectado
    if not fqbn then
        fqbn = "arduino:avr:uno"  -- Define um valor padrão
        print("FQBN desconhecido. Usando padrão: " .. fqbn)
    end

    print("Placa identificada: Porta = " .. port .. ", FQBN = " .. fqbn)

    -- Monta o comando para compilar e fazer upload
    local filename = vim.fn.expand('%:p') -- Caminho completo do arquivo atual
    local command = string.format("arduino-cli.exe compile --upload --fqbn %s -p %s %s", fqbn, port, filename)

    -- Abre um terminal e executa o comando
    vim.cmd('split | resize 15 | terminal ' .. command)
end

-- Função para ler o arquivo sketch.yaml e obter fqbn e port
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

-- Função para compilar e fazer upload
function Arduino.Yaml()
    local fqbn, port = ReadSketchConfig()
    if not fqbn or not port then return end

    local filename = vim.fn.expand('%:p') -- Caminho do arquivo atual
    local command = string.format("arduino-cli.exe compile --upload --fqbn %s -p %s %s", fqbn, port, filename)

    print("Enviando para " .. port .. " com fqbn " .. fqbn)
    vim.cmd('split | resize 15 | terminal ' .. command)
end

-- Mapeia <F3> para chamar a função de upload do Arduino
vim.api.nvim_set_keymap('n', '<F3>', '<cmd>lua Arduino.Upload()<CR>', { noremap = true, silent = true })


-- Mapeia a tecla F4 para chamar Arduino.Yaml
vim.api.nvim_set_keymap('n', '<F4>', ':lua Arduino.Yaml()<CR>', { noremap = true, silent = true })


-- Mapeamentos para criar e executar o Makefile
vim.api.nvim_set_keymap("n", "<F6>", [[:lua CreateMakefile()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F5>", [[:lua MakeAndRun()<CR>]], { noremap = true, silent = true })

-- Função para criar o Makefile para Arduino
function CreateMakefile()
    local filename = vim.fn.expand("%:t") -- Nome do arquivo com a extensão
    local filepath = vim.fn.expand("%:p")   -- Caminho completo do arquivo
    local fqbn, port = ReadSketchConfig()

    if not fqbn or not port then
        print("Não foi possível obter fqbn ou port do sketch.yaml.")
        return
    end

    -- Criando o conteúdo do Makefile para Arduino
    local makefile_content = string.format([[
    # Makefile para Arduino CLI

    # Configurações do Arduino CLI
    ARDUINO_CLI = arduino-cli.exe
    BOARD = %s          # Placa a ser usada
    PORT = %s           # Porta para upload
    SKETCH = %s         # Nome do arquivo com a extensão .ino
    BUILD_DIR = build

    # Compilar o código
    compile:
    $(ARDUINO_CLI) compile --fqbn $(BOARD) $(SKETCH)

    # Upload para a placa
    upload: compile
    $(ARDUINO_CLI) upload -p $(PORT) --fqbn $(BOARD) $(SKETCH)

    # Limpar arquivos de compilação
    clean:
    rm -rf $(BUILD_DIR)

    # Verificar o código
    verify:
    $(ARDUINO_CLI) verify --fqbn $(BOARD) $(SKETCH)
    ]], fqbn, port, filename)

    -- Criando o Makefile
    local makefile = io.open("Makefile", "w")
    if makefile then
        makefile:write(makefile_content)
        makefile:close()
        print("Makefile criado para " .. filename)
    else
        print("Erro ao criar Makefile")
    end
end
-- Função para compilar e fazer upload
function MakeAndRun()
    -- Executa make e verifica se a compilação foi bem-sucedida
    local result = vim.fn.system("make upload")
    if vim.v.shell_error == 0 then
        print("Upload bem-sucedido para o Arduino.")
    else
        print("Erro no upload para o Arduino.")
    end

end


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


-- Função para mapear teclas de forma simplificada
-- Modo: 'n' (normal), 'i' (inserção), 'v' (visual), 't' (terminal)
-- Tecla: A combinação de teclas a ser mapeada
-- Ação: O comando ou função a ser executada
-- Opções: Tabela de opções (noremap, silent, etc.)
--
local function map_keys(mode, keys, action, opts)
    opts = opts or {}
    opts.noremap = opts.noremap == nil and true or opts.noremap -- Ativa noremap por padrão
    opts.silent = opts.silent == nil and true or opts.silent -- Ativa silent por padrão
    vim.api.nvim_set_keymap(mode, keys, action, opts)
end

-- Mapeamentos para navegar entre placeholders nos snippets

-- Avança para o próximo placeholder no modo de inserção
map_keys('i', '<Tab>', '<CMD>lua require("luasnip").jump(1)<CR>')

-- Avança para o próximo placeholder no modo de seleção
map_keys('s', '<Tab>', '<CMD>lua require("luasnip").jump(1)<CR>')

-- Volta para o placeholder anterior no modo de inserção (usando Alt + Tab)
map_keys('i', '<A-Tab>', '<CMD>lua require("luasnip").jump(-1)<CR>')

-- Volta para o placeholder anterior no modo de seleção (usando Alt + Tab)
map_keys('s', '<A-Tab>', '<CMD>lua require("luasnip").jump(-1)<CR>')



