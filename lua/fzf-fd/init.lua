local M = {}
local fzf = require("fzf")

require("fzf").default_options = {
    window_on_create = function()
        vim.cmd("set winhl=Normal:Normal")
    end
}

M.run = function()
    coroutine.wrap(function()
        local result = fzf.fzf("fd -HI --ignore-file ~/.ignore -c always ", "--ansi --multi --reverse")
        if result then
            for _, file in ipairs(result) do
                vim.cmd("edit " .. file)
            end
        end
    end)()
end

return M
