

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
    -- Snippet para criar função em C
    luasnip.snippet("fun", {
        -- Primeiro placeholder: tipo de retorno (padrão: 'int')
        luasnip.insert_node(1, "int"),
        -- Texto fixo: espaço após o tipo
        luasnip.text_node(" "),
        -- Segundo placeholder: nome da função (padrão: 'nome_da_funcao')
        luasnip.insert_node(2, "nome_da_funcao"),
        -- Texto fixo: abertura de parênteses
        luasnip.text_node("("),
        -- Terceiro placeholder: argumentos (padrão: 'int a, int b')
        luasnip.insert_node(3, "int a, int b"),
        -- Texto fixo: fechamento de parênteses e abertura de chaves
        luasnip.text_node(") {"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Quarto placeholder: bloco de código (padrão: '// código aqui')
        luasnip.insert_node(4, "// código aqui"),
        -- Texto fixo: fechamento de chaves
        luasnip.text_node({ "", "}" }),
    }),


}



-- Adiciona os snippets ao LuaSnip para o tipo de arquivo 'c'
luasnip.add_snippets('c', snippets)

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


-- Configurações específicas para arquivos C
--
local function setup_c_specifics()
    vim.opt_local.path:append('/usr/include')
end

-- Aplicar configurações apenas para arquivos C
if vim.bo.filetype == 'c' then
    setup_c_specifics()
end


-- Mapeamentos para criar e executar o Makefile
vim.api.nvim_set_keymap("n", "<F6>", [[:lua CreateMakefile()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F5>", [[:lua MakeAndRun()<CR>]], { noremap = true, silent = true })

function CreateMakefile()
    local filename = vim.fn.expand("%:t:r") -- Nome do arquivo sem extensão
    local filepath = vim.fn.expand("%:p")   -- Caminho completo do arquivo
    local libs = {}

    -- Mapeamento de bibliotecas padrão para flags do GCC
    local lib_map = {
        ["math.h"] = "m",
        ["pthread.h"] = "pthread",
        ["ncurses.h"] = "ncurses",
        ["GL/gl.h"] = "GL",
        ["GL/freeglut.h"] = "glut",
        ["SDL2/SDL.h"] = "SDL2",
        ["SDL.h"] = "SDL",
        ["curl/curl.h"] = "curl",
    }

    -- Lendo o arquivo e extraindo bibliotecas
    local file = io.open(filepath, "r")
    if file then
        for line in file:lines() do
            local header = line:match('#include%s+["<](.-)[">]')
            if header and lib_map[header] then
                table.insert(libs, "-l" .. lib_map[header])
            end
        end
        file:close()
    end

    -- Criando a linha de bibliotecas para o compilador
    local lib_flags = table.concat(libs, " ")

    -- Criando o conteúdo do Makefile
    local makefile_content = string.format([[
    CC=gcc
    CFLAGS=-Wall -Wextra -std=c11
    LDFLAGS=%s
    TARGET=%s

    all: $(TARGET)

    $(TARGET): %s.c
    $(CC) $(CFLAGS) -o $(TARGET) %s.c $(LDFLAGS)

    clean:
    rm -f $(TARGET)

    run: all
    ./$(TARGET)
    ]], lib_flags, filename, filename, filename)

    -- Criando o Makefile
    local makefile = io.open("Makefile", "w")
    if makefile then
        makefile:write(makefile_content)
        makefile:close()
        print("Makefile criado para " .. filename .. ".c")
    else
        print("Erro ao criar Makefile")
    end
end

function MakeAndRun()
    -- Executa make e verifica se a compilação foi bem-sucedida
    local result = vim.fn.system("make")
    if vim.v.shell_error == 0 then
        print("Compilação bem-sucedida. Executando...")

        -- Abrir um split horizontal, ajustar tamanho e rodar o programa no terminal
        local command = "./" .. vim.fn.expand("%:t:r")
        vim.cmd('split | resize 15 | terminal ' .. command)
    else
        print("Erro na compilação.")
    end
end

