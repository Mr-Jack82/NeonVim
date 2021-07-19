require "core.global"
require "core.options"
require "core.mappings"
require "modules.plugins"
local async
async = vim.loop.new_async(vim.schedule_wrap(function()
    if vim.api.nvim_buf_get_name(0):len() == 0 then
        vim.cmd "Startify"
    end
    async:close()
end))
async:send()
