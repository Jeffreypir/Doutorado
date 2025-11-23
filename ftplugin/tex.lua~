
-- Aliases para comandos comuns
local set = vim.opt -- Configurações do Neovim
local map = vim.api.nvim_set_keymap -- Mapeamento de teclas
local cmd = vim.cmd -- Executar comandos do Vimscript
local g = vim.g -- Variáveis globais do Vim

-- [[
-- Configuração do tex em lua 
-- Função para mapear teclas de forma simplificada
-- Modo: 'n' (normal), 'i' (inserção), 'v' (visual), 't' (terminal)
-- Tecla: A combinação de teclas a ser mapeada
-- Ação: O comando ou função a ser executada
-- Opções: Tabela de opções (noremap, silent, etc.)
--]]
local function map_keys(mode, keys, action, opts)
    opts = opts or {}
    opts.noremap = opts.noremap == nil and true or opts.noremap -- Ativa noremap por padrão
    opts.silent = opts.silent == nil and true or opts.silent -- Ativa silent por padrão
    map(mode, keys, action, opts)
end

-- Mapeamentos para o modo normal
--map_keys('n', '<F3>', ':!open-in-windows %<.pdf & <CR> <CR>') -- Abrir o explorador de arquivos
map_keys('n', '<F3>', ':!sumatrapdf.exe %<.pdf & <CR> <CR>') -- Abrir o explorador de arquivos
map_keys('n', '<F4>', ':!biber %< & <CR> <CR>') -- Abrir o explorador de arquivos
map_keys('n', '<C-S>', '<Cmd>TexlabForward<CR>') -- Procura arquivo

-- Mapear F5 para compilar o arquivo atual com lualatex
vim.api.nvim_set_keymap(
    "n",            -- modo normal
    "<F5>",         -- tecla
    ":w<CR>:!lualatex -interaction=nonstopmode %<CR>", -- comando
    { noremap = true, silent = false } -- opções
)

-- Mapeia F6 para rodar pdf2png.sh na pasta do arquivo atual
vim.api.nvim_set_keymap(
    "n",                        -- modo normal
    "<F6>",                     -- tecla F6
    ":w<CR>:!pdfPngLatex %:p:h<CR>",  -- comando
    { noremap = true, silent = false }
)

-- Mapeia F7 para inserir um template LaTeX pronto
vim.keymap.set("n", "<F7>", function()
    local template_path = vim.fn.expand("$HOME/.config/nvim/after/template/templateLatexPng")

    if vim.fn.filereadable(template_path) == 1 then
        vim.cmd("0read " .. template_path)
        print("✅ Template LaTeX carregado de " .. template_path)
    else
        print("⚠️ Template não encontrado em " .. template_path)
    end
end, { noremap = true, silent = true, desc = "Inserir template LaTeX" })

-- Arquivo tex.lua para snippets de LaTeX usando LuaSnip no Neovim
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = require("luasnip.extras").rep

ls.add_snippets("tex", {

    -- Snippet para criar um ambiente LaTeX genérico
    -- Exemplo de uso: Digite "env equation" e pressione Tab
    s({ trig = "env (%w+)", regTrig = true, desc = "Cria um ambiente LaTeX" }, {
        f(function(_, snip)
            return "\\begin{" .. (snip.captures[1]) .. "}"
        end, {}),
        t({ "", "\t" }), i(1, "conteúdo"),
        t({ "", "\\end{" }),
        f(function(_, snip)
            return (snip.captures[1]) .. "}"
        end, {}),
    }),

    -- Snippet para inserir um comando LaTeX com argumentos opcionais e obrigatórios
    -- Exemplo de uso: Digite "cmd" e pressione Tab
    s({ trig = "cmd", desc = "Comando LaTeX com argumentos" }, {
        t("\\"), i(1, "comando"), t("["), i(2, "opcional"), t("]{"), i(3, "obrigatório"), t("}"),
    }),

    -- Snippet para criar uma lista itemizada
    -- Exemplo de uso: Digite "itemize" e pressione Tab
    s({ trig = "itemize", desc = "Cria uma lista itemizada" }, {
        t("\\begin{itemize}"),
        t({ "", "\t\\item " }), i(1, "item 1"),
        t({ "", "\t\\item " }), i(2, "item 2"),
        t({ "", "\t\\item " }), i(3, "item 3"),
        t({ "", "\\end{itemize}" }),
    }),

    -- Snippet para inserir uma figura
    -- Exemplo de uso: Digite "fig" e pressione Tab
    s({ trig = "fig", desc = "Inserir figura" }, {
        t("\\begin{figure}[h]"),
        t({ "", "\t\\centering" }),
        t({ "", "\t\\includegraphics[width=" }), i(1, "0.8\\textwidth"), t("]{"), i(2, "imagem"), t("}"),
        t({ "", "\t\\caption{" }), i(3, "descrição da figura"), t("}"),
        t({ "", "\t\\label{fig:" }), i(4, "rotulo"), t("}"),
        t({ "", "\\end{figure}" }),
    }),

    -- Snippet para criar uma tabela
    -- Exemplo de uso: Digite "table" e pressione Tab
    s({ trig = "table", desc = "Criar tabela" }, {
        t("\\begin{table}[h]"),
        t({ "", "\t\\centering" }),
        t({ "", "\t\\begin{tabular}{" }), i(1, "c|c|c"), t("}"),
        t({ "", "\t\t" }), i(2, "dados da tabela"),
        t({ "", "\t\\end{tabular}" }),
        t({ "", "\t\\caption{" }), i(3, "descrição da tabela"), t("}"),
        t({ "", "\t\\label{tab:" }), i(4, "rotulo"), t("}"),
        t({ "", "\\end{table}" }),
    }),

    -- Snippet para inserir uma equação matemática
    -- Exemplo de uso: Digite "eq" e pressione Tab
    s({ trig = "eq", desc = "Inserir equação" }, {
        t("\\begin{equation}"),
        t({ "", "\t" }), i(1, "f(x) = x^2"),
        t({ "", "\\end{equation}" }),
    }),

    -- Snippet para inserir um hyperlink
    -- Exemplo de uso: Digite "link" e pressione Tab
    s({ trig = "link", desc = "Inserir hyperlink" }, {
        t("\\href{"), i(1, "url"), t("}{"), i(2, "texto"), t("}"),
    }),

    -- Snippet para inserir uma nota de rodapé
    -- Exemplo de uso: Digite "footnote" e pressione Tab
    s({ trig = "footnote", desc = "Inserir nota de rodapé" }, {
        t("\\footnote{"), i(1, "texto da nota"), t("}"),
    }),

    -- Snippet para criar um comando personalizado
    -- Exemplo de uso: Digite "newcommand" e pressione Tab
    s({ trig = "newcommand", desc = "Criar comando personalizado" }, {
        t("\\newcommand{\\"), i(1, "comando"), t("}{"), i(2, "definição"), t("}"),
    }),

    -- Snippet para criar um ambiente align (alinhar equações matemáticas)
    -- Exemplo de uso: Digite "align" e pressione Tab
    s({ trig = "align", desc = "Cria um ambiente align para alinhar equações" }, {
        t("\\begin{align}"),
        t({ "", "\t" }), i(1, "equação 1"), t(" & "), i(2, "condição 1"), t(" \\\\"),
        t({ "", "\t" }), i(3, "equação 2"), t(" & "), i(4, "condição 2"), t(" \\\\"),
        t({ "", "\\end{align}" }),
    }),

    -- Snippet para gerar a estrutura básica de um documento LaTeX
    -- Exemplo de uso: Digite "doc" e pressione Tab
    s({ trig = "doc", desc = "Estrutura básica de um documento LaTeX" }, {
        t("\\documentclass[12pt, a4paper]{"), i(1, "article"), t("}"),
        t({ "", "\\usepackage[utf8]{inputenc}" }),
        t({ "", "\\usepackage[brazil]{babel}" }),
        t({ "", "\\usepackage{graphicx}" }),
        t({ "", "\\usepackage{amsmath}" }),
        t({ "", "\\usepackage{amsfonts}" }),
        t({ "", "\\usepackage{amssymb}" }),
        t({ "", "\\usepackage{cite}" }),
        t({ "", "\\usepackage{hyperref}" }),
        t({ "", "\\title{" }), i(2, "Título do Documento"), t("}"),
        t({ "", "\\author{Jefferson Bezerra dos Santos}" }),
        t({ "", "\\date{" }), i(3, "\\today"), t("}"),
        t({ "", "\\begin{document}" }),
        t({ "", "\\maketitle" }),
        i(4, "Conteúdo do documento"),
        t({ "", "\\end{document}" }),
    }),

    -- Beamer
    s({ trig = "beamer", desc = "Cria um documento Beamer básico" }, {
        t({ "\\documentclass[12pt]{beamer}",
            "\\usepackage[utf8]{inputenc}",
            "\\usepackage[brazil]{babel}",
            "\\usepackage{amsmath} % Para fórmulas matemáticas",
            "\\usepackage{xcolor} % Para usar cores",
            "",
            "\\usetheme{Berkeley}",
            "",
            "% Definir cores para títulos e subtítulos",
            "\\setbeamercolor{frametitle}{fg=white}",
            "\\setbeamercolor{framesubtitle}{fg=green}",
            "",
            "\\title{" }), i(1, "Título da Apresentação"), t("}"),
        t({ "", "\\author{" }), i(2, "Nome do Autor"), t("}"),
        t({ "", "\\date{}", "", "\\begin{document}", "", "\\frame{\\titlepage}", "", "% Slide do sumário", "" }),
        t({ "\\begin{frame}", "\t\\frametitle{Sumário}", "\t\\tableofcontents", "\\end{frame}", "" }),
        t({ "", "" }),
        t({ "\\begin{frame}", "\t\\section{" }), i(3, "Título da Seção"), t("}"),
        t({ "", "" }),
        t({ "\t\\frametitle{" }), rep(3), t("}"),
        t({ "", "" }),
        t({ "\t\\framesubtitle{" }), i(4, "Subtítulo"), t("}"),
        t({ "", "" }),
        t({ "\t\\begin{itemize}", "\t\t\\item " }), i(5, "Item 1"),
        t({ "", "\t\t\\item " }), i(6, "Item 2"),
        t({ "", "\t\t\\item " }), i(7, "Item 3"),
        t({ "", "\t\\end{itemize}", "\\end{frame}", "", "\\end{document}" })
    }),


})

vim.keymap.set("i", "<Space>", function()
  local ls = require("luasnip")
  if ls.expandable() then
    return "<Plug>luasnip-expand-snippet"
  else
    return " "
  end
end, { expr = true })


-- Mapeamento para carregar o template de tex
vim.api.nvim_set_keymap(
    "n", -- Modo Normal
    "<leader>t", -- Combinação de teclas (leader + ct)
    "", -- Comando vazio (será substituído pela função)
    { -- Opções
        noremap = true, -- Não re-mapear
        silent = true, -- Silencioso
        callback = function() -- Função a ser executada
            carregar_template(vim.fn.expand("$HOME/.config/nvim/after/template/template_aula.tex"))
        end,
    }
)


