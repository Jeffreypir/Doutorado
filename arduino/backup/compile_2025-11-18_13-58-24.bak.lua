local M = {}

function M.run()
    vim.cmd("silent !arduino-cli.exe compile --build-path ./build")
    vim.cmd("silent !cp build/compile_commands.json .")
    vim.cmd("silent !rm -rf build/ .cache/")
    vim.cmd("silent !fix_compile_commands")
end

return M

