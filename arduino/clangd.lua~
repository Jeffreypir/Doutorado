local M = {}

function M.generate()
    local path = vim.fn.expand("%:p:h")
    local file = path .. "/.clangd"

    if vim.fn.filereadable(file) == 1 then
        return
    end

    local handle = io.popen('cmd.exe /c "echo %USERNAME%"')
    local username = handle:read("*l") or "Public"
    handle:close()

    username = username:gsub("%s+", "")

    local base = "/mnt/c/Users/" .. username
    local lib_root = base .. "/Documents/Arduino/libraries"

    local flags = {
        "-include=" .. base .. "/AppData/Local/Arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/avr/include",
        "-isystem", base .. "/AppData/Local/Arduino15/packages/arduino/hardware/avr/1.8.6/cores/arduino",
        "-isystem", base .. "/AppData/Local/Arduino15/packages/arduino/hardware/avr/1.8.6/variants/standard",
        "-I", ".",
    }

    local p = io.popen('find "' .. lib_root .. '" -type f -name "*.h" -printf "%h\\n" | sort -u')
    if p then
        for line in p:lines() do
            table.insert(flags, "-isystem")
            table.insert(flags, line)
        end
        p:close()
    end

    local content = "CompileFlags:\n  Add: [\n"
    for _, f in ipairs(flags) do
        content = content .. '    "' .. f .. '",\n'
    end
    content = content .. "  ]\n"

    local f = io.open(file, "w")
    if f then
        f:write(content)
        f:close()
        print(".clangd criado em " .. path)
    end
end

return M

