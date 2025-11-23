
--[[===================== R  ================================
                Author:Jefferson Bezerra dos Santos
--]]--===========================================================

-- Configuração do R 
-- Função para mapear teclas de forma simplificada
-- Modo: 'n' (normal), 'i' (inserção), 'v' (visual), 't' (terminal)
-- Tecla: A combinação de teclas a ser mapeada
-- Ação: O comando ou função a ser executada
-- Opções: Tabela de opções (noremap, silent, etc.)
--]]
--
-- Função para mapear teclas de forma simplificada
local function map_keys(mode, keys, action, opts)
    opts = opts or {}
    opts.noremap = opts.noremap == nil and true or opts.noremap -- Ativa noremap por padrão
    opts.silent = opts.silent == nil and true or opts.silent -- Ativa silent por padrão
    vim.api.nvim_set_keymap(mode, keys, action, opts)
end

-- Atalhos para inserir pares de caracteres no modo de inserção

-- Inserir {} e posicionar o cursor entre as chaves
map_keys('i', '{', '{}<ESC>i')

-- Inserir [] e posicionar o cursor entre os colchetes
map_keys('i', '[', '[]<ESC>i')

-- Inserir () e posicionar o cursor entre os parênteses
map_keys('i', '(', '()<ESC>i')

-- Inserir "" e posicionar o cursor entre as aspas
map_keys('i', '"', '""<ESC>i')

-- Inserir '' e posicionar o cursor entre as aspas simples
map_keys('i', "'", "''<ESC>i")

-- Carrega o módulo LuaSnip para gerenciar snippets
local luasnip = require('luasnip')

-- Define snippets específicos para arquivos R
local snippets = {

    -- Snippet para criar uma função em R
    -- Uso: Digite `fun` e pressione Tab.
    -- Exemplo:
    -- minha_funcao <- function(arg1, arg2) {
    --     # corpo da função
    -- }
    luasnip.snippet("fun", {
        -- Texto fixo: início da função
        luasnip.text_node(""),
        -- Primeiro placeholder: nome da função (padrão: 'minha_funcao')
        luasnip.insert_node(1, "minha_funcao"),
        -- Texto fixo: operador de atribuição e palavra-chave 'function'
        luasnip.text_node(" <- function("),
        -- Segundo placeholder: argumentos (padrão: 'arg1, arg2')
        luasnip.insert_node(2, "arg1, arg2"),
        -- Texto fixo: fechamento dos parênteses e abertura das chaves
        luasnip.text_node(") {"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Terceiro placeholder: corpo da função (padrão: '# corpo da função')
        luasnip.insert_node(3, "# corpo da função"),
        -- Texto fixo: fechamento das chaves
        luasnip.text_node({ "", "}" }),
    }),

    -- Snippet para criar um vetor
    -- Uso: Digite `vec` e pressione Tab.
    -- Exemplo:
    -- meu_vetor <- c(1, 2, 3)
    luasnip.snippet("vec", {
        -- Texto fixo: início do vetor
        luasnip.text_node(""),
        -- Primeiro placeholder: nome do vetor (padrão: 'meu_vetor')
        luasnip.insert_node(1, "meu_vetor"),
        -- Texto fixo: operador de atribuição e função 'c'
        luasnip.text_node(" <- c("),
        -- Segundo placeholder: elementos do vetor (padrão: '1, 2, 3')
        luasnip.insert_node(2, "1, 2, 3"),
        -- Texto fixo: fechamento dos parênteses
        luasnip.text_node(")"),
    }),

    -- Snippet para criar um data frame
    -- Uso: Digite `df` e pressione Tab.
    -- Exemplo:
    -- meu_df <- data.frame(
    --     col1 = c(1, 2, 3),
    --     col2 = c("a", "b", "c")
    -- )
    luasnip.snippet("df", {
        -- Texto fixo: início do data frame
        luasnip.text_node(""),
        -- Primeiro placeholder: nome do data frame (padrão: 'meu_df')
        luasnip.insert_node(1, "meu_df"),
        -- Texto fixo: operador de atribuição e função 'data.frame'
        luasnip.text_node(" <- data.frame("),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Segundo placeholder: colunas do data frame (padrão: 'col1 = c(1, 2, 3)')
        luasnip.insert_node(2, "col1 = c(1, 2, 3)"),
        -- Texto fixo: vírgula e quebra de linha
        luasnip.text_node({ "", "\t" }),
        -- Terceiro placeholder: mais colunas (padrão: 'col2 = c("a", "b", "c")')
        luasnip.insert_node(3, 'col2 = c("a", "b", "c")'),
        -- Texto fixo: fechamento dos parênteses
        luasnip.text_node({ "", ")" }),
    }),

    -- Snippet para criar um loop 'for'
    -- Uso: Digite `for` e pressione Tab.
    -- Exemplo:
    -- for (i in 1:10) {
    --     # corpo do loop
    -- }
    luasnip.snippet("for", {
        -- Texto fixo: início do loop
        luasnip.text_node("for ("),
        -- Primeiro placeholder: variável do loop (padrão: 'i')
        luasnip.insert_node(1, "i"),
        -- Texto fixo: 'in' e intervalo
        luasnip.text_node(" in 1:"),
        -- Segundo placeholder: limite do loop (padrão: '10')
        luasnip.insert_node(2, "10"),
        -- Texto fixo: fechamento dos parênteses e abertura das chaves
        luasnip.text_node(") {"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Terceiro placeholder: corpo do loop (padrão: '# corpo do loop')
        luasnip.insert_node(3, "# corpo do loop"),
        -- Texto fixo: fechamento das chaves
        luasnip.text_node({ "", "}" }),
    }),

    -- Snippet para criar uma condicional 'if'
    -- Uso: Digite `if` e pressione Tab.
    -- Exemplo:
    -- if (condição) {
    --     # bloco if
    -- }
    luasnip.snippet("if", {
        -- Texto fixo: início da condicional
        luasnip.text_node("if ("),
        -- Primeiro placeholder: condição (padrão: 'condição')
        luasnip.insert_node(1, "condição"),
        -- Texto fixo: fechamento dos parênteses e abertura das chaves
        luasnip.text_node(") {"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Segundo placeholder: bloco if (padrão: '# bloco if')
        luasnip.insert_node(2, "# bloco if"),
        -- Texto fixo: fechamento das chaves
        luasnip.text_node({ "", "}" }),
    }),

    -- Snippet para criar uma condicional 'if-else'
    -- Uso: Digite `ife` e pressione Tab.
    -- Exemplo:
    -- if (condição) {
    --     # bloco if
    -- } else {
    --     # bloco else
    -- }
    luasnip.snippet("ife", {
        -- Texto fixo: início da condicional
        luasnip.text_node("if ("),
        -- Primeiro placeholder: condição (padrão: 'condição')
        luasnip.insert_node(1, "condição"),
        -- Texto fixo: fechamento dos parênteses e abertura das chaves
        luasnip.text_node(") {"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Segundo placeholder: bloco if (padrão: '# bloco if')
        luasnip.insert_node(2, "# bloco if"),
        -- Texto fixo: fechamento das chaves e início do bloco else
        luasnip.text_node({ "", "} else {" }),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Terceiro placeholder: bloco else (padrão: '# bloco else')
        luasnip.insert_node(3, "# bloco else"),
        -- Texto fixo: fechamento das chaves
        luasnip.text_node({ "", "}" }),
    }),

    -- Snippet para criar um gráfico básico com 'plot'
    -- Uso: Digite `plot` e pressione Tab.
    -- Exemplo:
    -- plot(x, y, main = "Título do Gráfico", xlab = "Eixo X", ylab = "Eixo Y")
    luasnip.snippet("plot", {
        -- Texto fixo: início da função plot
        luasnip.text_node("plot("),
        -- Primeiro placeholder: variável x (padrão: 'x')
        luasnip.insert_node(1, "x"),
        -- Texto fixo: vírgula e espaço
        luasnip.text_node(", "),
        -- Segundo placeholder: variável y (padrão: 'y')
        luasnip.insert_node(2, "y"),
        -- Texto fixo: título e rótulos dos eixos
        luasnip.text_node(', main = "Título do Gráfico", xlab = "Eixo X", ylab = "Eixo Y"'),
        -- Texto fixo: fechamento dos parênteses
        luasnip.text_node(")"),
    }),

    -- Snippet para criar um gráfico de dispersão com 'ggplot2'
    -- Uso: Digite `gg` e pressione Tab.
    -- Exemplo:
    -- ggplot(data, aes(x = col1, y = col2)) +
    --     geom_point()
    luasnip.snippet("gg", {
        -- Texto fixo: início da função ggplot
        luasnip.text_node("ggplot("),
        -- Primeiro placeholder: nome do data frame (padrão: 'data')
        luasnip.insert_node(1, "data"),
        -- Texto fixo: função aes e eixos
        luasnip.text_node(', aes(x = '),
        -- Segundo placeholder: coluna do eixo x (padrão: 'col1')
        luasnip.insert_node(2, "col1"),
        -- Texto fixo: vírgula e eixo y
        luasnip.text_node(', y = '),
        -- Terceiro placeholder: coluna do eixo y (padrão: 'col2')
        luasnip.insert_node(3, "col2"),
        -- Texto fixo: fechamento dos parênteses e operador de adição
        luasnip.text_node(")) +"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Quarto placeholder: camada do gráfico (padrão: 'geom_point()')
        luasnip.insert_node(4, "geom_point()"),
    }),

    -- Snippet para criar uma regressão linear
    -- Uso: Digite `lm` e pressione Tab.
    -- Exemplo:
    -- modelo <- lm(y ~ x, data = meu_df)
    luasnip.snippet("lm", {
        -- Texto fixo: início da função lm
        luasnip.text_node(""),
        -- Primeiro placeholder: nome do modelo (padrão: 'modelo')
        luasnip.insert_node(1, "modelo"),
        -- Texto fixo: operador de atribuição e função lm
        luasnip.text_node(" <- lm("),
        -- Segundo placeholder: fórmula da regressão (padrão: 'y ~ x')
        luasnip.insert_node(2, "y ~ x"),
        -- Texto fixo: data frame
        luasnip.text_node(', data = '),
        -- Terceiro placeholder: nome do data frame (padrão: 'meu_df')
        luasnip.insert_node(3, "meu_df"),
        -- Texto fixo: fechamento dos parênteses
        luasnip.text_node(")"),
    }),

    -- Snippet para criar um teste t
    -- Uso: Digite `ttest` e pressione Tab.
    -- Exemplo:
    -- resultado <- t.test(x, y)
    luasnip.snippet("ttest", {
        -- Texto fixo: início da função t.test
        luasnip.text_node(""),
        -- Primeiro placeholder: nome do resultado (padrão: 'resultado')
        luasnip.insert_node(1, "resultado"),
        -- Texto fixo: operador de atribuição e função t.test
        luasnip.text_node(" <- t.test("),
        -- Segundo placeholder: variáveis (padrão: 'x, y')
        luasnip.insert_node(2, "x, y"),
        -- Texto fixo: fechamento dos parênteses
        luasnip.text_node(")"),
    }),

    -- Snippet para função 'print'
    -- Uso: Digite `print` e pressione Tab.
    -- Exemplo:
    -- print("Olá, mundo!")
    luasnip.snippet("print", {
        -- Texto fixo: início da função print
        luasnip.text_node('print("'),
        -- Primeiro placeholder: mensagem (padrão: 'Olá, mundo!')
        luasnip.insert_node(1, "message"),
        -- Texto fixo: fechamento da função print
        luasnip.text_node('")'),
    }),

}

-- Adiciona os snippets ao LuaSnip
luasnip.add_snippets("r", snippets)
