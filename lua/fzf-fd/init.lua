local M = {}
local fzf = require("fzf")

require("fzf").default_options = {
    window_on_create = function()
        vim.cmd("set winhl=Normal:Normal")
    end
}

local function get_search_path_opt()
    local search_path = vim.fn.system("git rev-parse --show-cdup 2>/dev/null"):gsub("%s+$", "")
    if search_path == "" then
        return ""
    else
        return "--search-path " .. search_path
    end
end

local search_path_opt = get_search_path_opt()
local source = 'fd -HI --ignore-file ~/.ignore -c always -t f ' .. search_path_opt
local options = {
    "--ansi",
    "--multi",
    "--reverse",
    "--preview 'bat --plain --number --color always {}'",
    "--preview-window down:70%",
    "--bind 'alt-h:reload:fd -HI -c always -t f " .. search_path_opt .. "'",
}

M.run = function()
    coroutine.wrap(function()
        local result = fzf.fzf(source, table.concat(options, " "))
        if result then
            for _, file in ipairs(result) do
                vim.cmd("edit " .. file)
            end
        end
    end)()
end

return M
