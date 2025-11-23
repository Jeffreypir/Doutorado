local M = {}

-- Diretorios com arquivos para configura o projeto
local HOME = vim.env.HOME
local DIR_UNO = HOME .. "/.config/nvim/after/fqbn/uno/"

-- Lista de arquivos para copiar 
local FILES = {
    "compile_commands.json",
    "sketch.yaml",
    "Makefile",
}

function M.setup()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "arduino",
        callback = function(ev)

            -- flag para não repetir
            if vim.b[ev.buf].template_inserted then return end

            -- Arquivo novo/vazio?
            local name = vim.api.nvim_buf_get_name(ev.buf)
            local size = vim.fn.getfsize(name)

            if size <= 0 then
                require("arduino.template").insert()
                --require("arduino.attach").run()
                require("arduino.compile_commands").copyAll(FILES, DIR_UNO)
                require("arduino.clangd").generate()

                -- marca como inserido
                vim.b[ev.buf].template_inserted = true
            end
        end,
    })

    vim.api.nvim_create_user_command("ArduinoGenerateClangd", function()
        -- comando que será executado no terminal (Neovim headless)
        local gen_cmd = "nvim --headless +'lua require(\"arduino.clangd\").generate()' +qa\n"

        -- abre terminal em split inferior
        vim.cmd("botright 15split | terminal")

        local term_id = vim.b.terminal_job_id

        -- envia o comando para o terminal
        vim.fn.chansend(term_id, gen_cmd)

        -- aguarda um pouco e fecha o terminal automaticamente
        vim.defer_fn(function()
            -- fecha o terminal sem mensagens
            vim.cmd("silent! close")
        end, 500)  -- aguarda 500ms, ajuste se seu comando demorar mais

    end, {})


end

return M

