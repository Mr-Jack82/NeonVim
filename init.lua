vim.cmd "filetype off"
require "core.global"
require "core.options"
require "core.mappings"
local async
async = vim.loop.new_async(vim.schedule_wrap(function()
    require "modules.plugins"
    local compiled = vim.fn.stdpath "data"
        .. "/site/pack/packer/start/packer.nvim/plugin/packer_compiled.lua"
    if vim.fn.filereadable(compiled) > 0 then
        if vim.api.nvim_buf_get_name(0):len() == 0 then
            vim.cmd "Startify"
        end
    end
    vim.cmd "filetype on"
    vim.cmd "doautocmd BufRead"
    vim.cmd "doautocmd ColorScheme"
    local ok, feline = pcall(require, "feline")
    if ok then
        feline.reset_highlights()
    end
    async:close()
end))
async:send()
