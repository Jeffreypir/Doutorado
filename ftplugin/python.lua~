
--[[===================== Python ================================
Author:Jefferson Bezerra dos Santos
--]]--===========================================================
-- Configuração do Pyhton 
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


-- Arquivo de snippets para Python no Neovim usando LuaSnip

-- Carrega o módulo LuaSnip para gerenciar snippets
local luasnip = require('luasnip')

-- Define snippets específicos para arquivos Python
local snippets = {

    -- Snippet para função Python
    -- Uso: Digite `fun` e pressione Tab.
    -- Exemplo:
    -- def minha_funcao(arg1, arg2):
    --     # função
    luasnip.snippet("fun", {
        -- Texto fixo: início da função
        luasnip.text_node("def "),
        -- Primeiro placeholder: nome da função (padrão: 'function_name')
        luasnip.insert_node(1, "function_name"),
        -- Texto fixo: abertura de parênteses para argumentos
        luasnip.text_node("("),
        -- Segundo placeholder: argumentos (padrão: 'args')
        luasnip.insert_node(2, "args"),
        -- Texto fixo: fechamento de parênteses e dois pontos
        luasnip.text_node("):"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Terceiro placeholder: bloco de código (padrão: '# função')
        luasnip.insert_node(3, "# função"),
    }),

    -- Snippet para classe Python
    -- Uso: Digite `class` e pressione Tab.
    -- Exemplo:
    -- class MinhaClasse:
    --     def __init__(self, arg1, arg2):
    --         # inicialização
    luasnip.snippet("class", {
        -- Texto fixo: início da classe
        luasnip.text_node("class "),
        -- Primeiro placeholder: nome da classe (padrão: 'ClassName')
        luasnip.insert_node(1, "ClassName"),
        -- Texto fixo: dois pontos
        luasnip.text_node(":"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Texto fixo: início do método __init__
        luasnip.text_node("def __init__(self, "),
        -- Segundo placeholder: argumentos (padrão: 'args')
        luasnip.insert_node(2, "args"),
        -- Texto fixo: fechamento de parênteses e dois pontos
        luasnip.text_node("):"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t\t" }),
        -- Terceiro placeholder: bloco de código (padrão: '# inicialização')
        luasnip.insert_node(3, "# inicialização"),
    }),

    -- Snippet para condicional 'if'
    -- Uso: Digite `if` e pressione Tab.
    -- Exemplo:
    -- if x > 10:
    --     # bloco if
    luasnip.snippet("if", {
        -- Texto fixo: início da condicional
        luasnip.text_node("if "),
        -- Primeiro placeholder: condição (padrão: 'condição')
        luasnip.insert_node(1, "condição"),
        -- Texto fixo: dois pontos
        luasnip.text_node(":"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Segundo placeholder: bloco de código (padrão: '# bloco if')
        luasnip.insert_node(2, "# bloco if"),
    }),

    -- Snippet para condicional 'if-else'
    -- Uso: Digite `ife` e pressione Tab.
    -- Exemplo:
    -- if x > 10:
    --     # bloco if
    -- else:
    --     # bloco else
    luasnip.snippet("ife", {
        -- Texto fixo: início da condicional
        luasnip.text_node("if "),
        -- Primeiro placeholder: condição (padrão: 'condição')
        luasnip.insert_node(1, "condição"),
        -- Texto fixo: dois pontos
        luasnip.text_node(":"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Segundo placeholder: bloco if (padrão: '# bloco if')
        luasnip.insert_node(2, "# bloco if"),
        -- Texto fixo: início do bloco else
        luasnip.text_node({ "", "else:" }),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Terceiro placeholder: bloco else (padrão: '# bloco else')
        luasnip.insert_node(3, "# bloco else"),
    }),

    -- Snippet para loop 'for'
    -- Uso: Digite `for` e pressione Tab.
    -- Exemplo:
    -- for item in lista:
    --     # bloco for
    luasnip.snippet("for", {
        -- Texto fixo: início do loop
        luasnip.text_node("for "),
        -- Primeiro placeholder: item (padrão: 'item')
        luasnip.insert_node(1, "item"),
        -- Texto fixo: 'in'
        luasnip.text_node(" in "),
        -- Segundo placeholder: iterável (padrão: 'iterável')
        luasnip.insert_node(2, "iterável"),
        -- Texto fixo: dois pontos
        luasnip.text_node(":"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Terceiro placeholder: bloco de código (padrão: '# bloco for')
        luasnip.insert_node(3, "# bloco for"),
    }),

    -- Snippet para loop 'while'
    -- Uso: Digite `while` e pressione Tab.
    -- Exemplo:
    -- while x > 0:
    --     # bloco while
    luasnip.snippet("while", {
        -- Texto fixo: início do loop
        luasnip.text_node("while "),
        -- Primeiro placeholder: condição (padrão: 'condição')
        luasnip.insert_node(1, "condição"),
        -- Texto fixo: dois pontos
        luasnip.text_node(":"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Segundo placeholder: bloco de código (padrão: '# bloco while')
        luasnip.insert_node(2, "# bloco while"),
    }),

    -- Snippet para 'try-except'
    -- Uso: Digite `try` e pressione Tab.
    -- Exemplo:
    -- try:
    --     # bloco try
    -- except Exception as e:
    --     # bloco except
    luasnip.snippet("try", {
        -- Texto fixo: início do bloco try
        luasnip.text_node("try:"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Primeiro placeholder: bloco try (padrão: '# bloco try')
        luasnip.insert_node(1, "# bloco try"),
        -- Texto fixo: início do bloco except
        luasnip.text_node({ "", "except " }),
        -- Segundo placeholder: exceção (padrão: 'Exception')
        luasnip.insert_node(2, "Exception"),
        -- Texto fixo: 'as'
        luasnip.text_node(" as "),
        -- Terceiro placeholder: variável de exceção (padrão: 'e')
        luasnip.insert_node(3, "e"),
        -- Texto fixo: dois pontos
        luasnip.text_node(":"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Quarto placeholder: bloco except (padrão: '# bloco except')
        luasnip.insert_node(4, "# bloco except"),
    }),

    -- Snippet para list comprehension
    -- Uso: Digite `lc` e pressione Tab.
    -- Exemplo:
    -- [x * 2 for x in range(10)]
    luasnip.snippet("lc", {
        -- Texto fixo: início da list comprehension
        luasnip.text_node("["),
        -- Primeiro placeholder: expressão (padrão: 'expressão')
        luasnip.insert_node(1, "expressão"),
        -- Texto fixo: 'for'
        luasnip.text_node(" for "),
        -- Segundo placeholder: item (padrão: 'item')
        luasnip.insert_node(2, "item"),
        -- Texto fixo: 'in'
        luasnip.text_node(" in "),
        -- Terceiro placeholder: iterável (padrão: 'iterável')
        luasnip.insert_node(3, "iterável"),
        -- Texto fixo: fechamento da list comprehension
        luasnip.text_node("]"),
    }),

    -- Snippet para dict comprehension
    -- Uso: Digite `dc` e pressione Tab.
    -- Exemplo:
    -- {x: x**2 for x in range(10)}
    luasnip.snippet("dc", {
        -- Texto fixo: início da dict comprehension
        luasnip.text_node("{"),
        -- Primeiro placeholder: chave (padrão: 'chave')
        luasnip.insert_node(1, "chave"),
        -- Texto fixo: ':'
        luasnip.text_node(": "),
        -- Segundo placeholder: valor (padrão: 'valor')
        luasnip.insert_node(2, "valor"),
        -- Texto fixo: 'for'
        luasnip.text_node(" for "),
        -- Terceiro placeholder: item (padrão: 'item')
        luasnip.insert_node(3, "item"),
        -- Texto fixo: 'in'
        luasnip.text_node(" in "),
        -- Quarto placeholder: iterável (padrão: 'iterável')
        luasnip.insert_node(4, "iterável"),
        -- Texto fixo: fechamento da dict comprehension
        luasnip.text_node("}"),
    }),

    -- Snippet para função lambda
    -- Uso: Digite `lambda` e pressione Tab.
    -- Exemplo:
    -- lambda x: x * 2
    luasnip.snippet("lambda", {
        -- Texto fixo: início da função lambda
        luasnip.text_node("lambda "),
        -- Primeiro placeholder: argumentos (padrão: 'args')
        luasnip.insert_node(1, "args"),
        -- Texto fixo: ':'
        luasnip.text_node(": "),
        -- Segundo placeholder: expressão (padrão: 'expressão')
        luasnip.insert_node(2, "expressão"),
    }),

    -- Snippet para função 'print'
    -- Uso: Digite `print` e pressione Tab.
    -- Exemplo:
    -- print("Olá, mundo!")
    luasnip.snippet("print", {
        -- Texto fixo: início da função print
        luasnip.text_node('print("'),
        -- Primeiro placeholder: mensagem (padrão: 'mensagem')
        luasnip.insert_node(1, "mensagem"),
        -- Texto fixo: fechamento da função print
        luasnip.text_node('")'),
    }),

    -- Snippet para 'import'
    -- Uso: Digite `import` e pressione Tab.
    -- Exemplo:
    -- import math
    luasnip.snippet("import", {
        -- Texto fixo: início do import
        luasnip.text_node("import "),
        -- Primeiro placeholder: módulo (padrão: 'módulo')
        luasnip.insert_node(1, "módulo"),
    }),

    -- Snippet para 'from-import'
    -- Uso: Digite `from` e pressione Tab.
    -- Exemplo:
    -- from math import sqrt
    luasnip.snippet("from", {
        -- Texto fixo: início do from-import
        luasnip.text_node("from "),
        -- Primeiro placeholder: módulo (padrão: 'módulo')
        luasnip.insert_node(1, "módulo"),
        -- Texto fixo: 'import'
        luasnip.text_node(" import "),
        -- Segundo placeholder: função/classe (padrão: 'função/classe')
        luasnip.insert_node(2, "função/classe"),
    }),

    -- Snippet para 'if __name__ == "__main__"'
    -- Uso: Digite `main` e pressione Tab.
    -- Exemplo:
    -- if __name__ == "__main__":
    --     # código principal
    luasnip.snippet("main", {
        -- Texto fixo: início da estrutura
        luasnip.text_node('if __name__ == "__main__":'),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Primeiro placeholder: bloco de código (padrão: '# código principal')
        luasnip.insert_node(1, "# código principal"),
    }),

    -- Snippet para docstring
    -- Uso: Digite `doc` e pressione Tab.
    -- Exemplo:
    -- """
    --     Descrição da função/classe
    --     :param x: descrição do parâmetro x
    --     :return: descrição do retorno
    -- """
    luasnip.snippet("doc", {
        -- Texto fixo: início da docstring
        luasnip.text_node('"""'),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Primeiro placeholder: descrição da função/classe (padrão: 'Descrição da função/classe')
        luasnip.insert_node(1, "Descrição da função/classe"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Segundo placeholder: parâmetro (padrão: ':param parâmetro: descrição')
        luasnip.text_node(":param "), luasnip.insert_node(2, "parâmetro"), luasnip.text_node(": "), luasnip.insert_node(3, "descrição"),
        -- Quebra de linha e tabulação
        luasnip.text_node({ "", "\t" }),
        -- Terceiro placeholder: retorno (padrão: ':return: descrição')
        luasnip.text_node(":return: "), luasnip.insert_node(4, "descrição"),
        -- Quebra de linha e fechamento da docstring
        luasnip.text_node({ "", '"""' }),
    }),

}

-- Adiciona os snippets ao LuaSnip
luasnip.add_snippets("python", snippets)

