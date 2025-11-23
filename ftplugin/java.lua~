local config = {
    cmd = {'/bin/jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)

-- ~/.config/nvim/ftplugin/java.lua
-- Configurações específicas para arquivos Java com LuaSnip

local luasnip = require('luasnip')

-- Define snippets específicos para Java
local snippets = {
    -- Snippet para método main
    luasnip.snippet("main", {
        luasnip.text_node("public static void main(String[] args) {"),
        luasnip.text_node({ "", "\t" }),
        luasnip.insert_node(0),
        luasnip.text_node({ "", "}" }),
    }),

    -- Snippet para System.out.println()
    luasnip.snippet("sout", {
        luasnip.text_node("System.out.println("),
        luasnip.insert_node(1, "\"Message\""),
        luasnip.text_node(");"),
    }),

    -- Snippet para loop for
    luasnip.snippet("for", {
        luasnip.text_node("for (int "),
        luasnip.insert_node(1, "i"),
        luasnip.text_node(" = 0; "),
        luasnip.function_node(function(args) return args[1][1] or "i" end, {1}),
        luasnip.text_node(" < "),
        luasnip.insert_node(2, "length"),
        luasnip.text_node("; "),
        luasnip.function_node(function(args) return args[1][1] or "i" end, {1}),
        luasnip.text_node("++) {"),
        luasnip.text_node({ "", "\t" }),
        luasnip.insert_node(0),
        luasnip.text_node({ "", "}" }),
    }),
}

-- Adiciona os snippets para Java
luasnip.add_snippets('java', snippets)

-- Função para mapear teclas
local function map_keys(mode, keys, action, opts)
    opts = opts or {}
    opts.noremap = opts.noremap == nil and true or opts.noremap
    opts.silent = opts.silent == nil and true or opts.silent
    vim.api.nvim_set_keymap(mode, keys, action, opts)
end

-- Mapeamentos para snippets
map_keys('i', '<Tab>', '<CMD>lua require("luasnip").jump(1)<CR>')
map_keys('s', '<Tab>', '<CMD>lua require("luasnip").jump(1)<CR>')
map_keys('i', '<A-Tab>', '<CMD>lua require("luasnip").jump(-1)<CR>')
map_keys('s', '<A-Tab>', '<CMD>lua require("luasnip").jump(-1)<CR>')

-- Exemplos de uso:
-- Digite "main" no modo de inserção e pressione <Tab> para gerar:
-- public static void main(String[] args) {
--     
-- }

-- Digite "sout" e pressione <Tab> para gerar:
-- System.out.println("Message");

-- Digite "for" e pressione <Tab> para gerar:
-- for (int i = 0; i < length; i++) {
--     
-- }

-- Compilação e execução
map_keys('n', '<F3>', ':w<CR>:!java %:r<CR>')

-- Configurações específicas para Java
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.bo.commentstring = '// %s'

-- Função para gerar getters/setters
function GenerateGettersSetters()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local new_lines = {}
    local private_vars = {}

    -- Encontra variáveis privadas
    for _, line in ipairs(lines) do
        local var = line:match('private%s+([%w<>]+)%s+([%w]+);')
        if var then
            local type, name = var:match('([%w<>]+)%s+([%w]+)')
            table.insert(private_vars, {type = type, name = name})
        end
    end

    -- Gera getters e setters
    for _, var in ipairs(private_vars) do
        local capitalized = var.name:sub(1,1):upper() .. var.name:sub(2)
        table.insert(new_lines, string.format('public %s get%s() { return this.%s; }', var.type, capitalized, var.name))
        table.insert(new_lines, string.format('public void set%s(%s %s) { this.%s = %s; }', capitalized, var.type, var.name, var.name, var.name))
    end

    -- Insere no buffer
    if #new_lines > 0 then
        vim.api.nvim_buf_set_lines(0, -1, -1, false, {""})
        vim.api.nvim_buf_set_lines(0, -1, -1, false, new_lines)
    end
end

-- Mapeamento para gerar getters/setters
map_keys('n', '<leader>gs', ':lua GenerateGettersSetters()<CR>')

