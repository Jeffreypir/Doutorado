-- ==============================
-- 💡 Configuração Moderna do Neovim com Packer
-- ==============================

-- Protege contra erro se packer não estiver instalado
local ok, packer = pcall(require, "packer")
if not ok then
    vim.notify("Packer não encontrado! Execute :PackerSync", vim.log.levels.WARN)
    return
end

-- Usa popup flutuante para interface do Packer
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- ==============================
--  Plugins
-- ==============================
packer.startup(function(use)
    -- Gerenciador do próprio packer
    use("wbthomason/packer.nvim")

    -- ---------- LSP e Ferramentas ----------
    use("neovim/nvim-lspconfig")
    use("williamboman/mason.nvim")
    use("mfussenegger/nvim-jdtls")
    use("mfussenegger/nvim-dap")

    -- ---------- Autocompletar ----------
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-omni",
            "saadparwaiz1/cmp_luasnip",
        },
    })

    -- ---------- Snippets ----------
    use({
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip").setup({ history = true, updateevents = "TextChanged,TextChangedI" })
        end,
    })

    -- ---------- Interface ----------
    use("nvim-tree/nvim-web-devicons") -- Icons
    use("nvim-lualine/lualine.nvim") -- Theme
    use("lukas-reineke/indent-blankline.nvim")
    use("yorik1984/lualine-theme.nvim") -- Theme for lualine
    use('nvim-tree/nvim-tree.lua') -- Explorer


    -- ------------ Temas --------------------
    use {"elvessousa/sobrio"}

    -- ---------- Syntax e Árvores ----------
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    })
    -- Identação python 
    use ("Vimjas/vim-python-pep8-indent")

    -- Sintaxe para Arduino
    use("sudar/vim-arduino-syntax")


    -- ---------- Markdown ----------
    use("artempyanykh/marksman")
    use({
        "dhruvasagar/vim-table-mode",
        config = function()
            vim.g.table_mode_corner = "|"
            vim.keymap.set("n", "<leader>tm", ":TableModeToggle<CR>", { desc = "Alternar modo tabela" })
        end,
    })
end)





