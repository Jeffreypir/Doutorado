local M = {}

function M.run()
    local output = vim.fn.system('arduino-cli.exe board list')

    local port = output:match("(COM%d+)") or "COM3"
    local fqbn = output:match("(%S+:%S+:%S+)") or "arduino:avr:uno"

    print("Porta: " .. port)
    print("FQBN: " .. fqbn)

    vim.cmd("!arduino-cli.exe board attach -p " .. port .. " -b " .. fqbn)
end

return M

