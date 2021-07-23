require "core.global"
require "core.options"
require "core.mappings"
require "modules.plugins"
local async
async = vim.loop.new_async(vim.schedule_wrap(function()
    vim.cmd "doautocmd ColorScheme"
    async:close()
end))
async:send()
