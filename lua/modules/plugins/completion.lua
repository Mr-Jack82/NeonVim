local M = {}
local map = vim.api.nvim_set_keymap
local fn = vim.fn

local with_text = function(text, icon)
    if as._default(vim.g.code_compe_item_with_text) then
        return text
    else
        return icon
    end
end

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
end

local function tab(fallback)
    local luasnip = require "luasnip"
    if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t "<C-n>", "n")
    elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(t "<Plug>luasnip-expand-or-jump", "")
    elseif check_back_space() then
        vim.fn.feedkeys(t "<tab>", "n")
    else
        fallback()
    end
end

local function shift_tab(fallback)
    local luasnip = require "luasnip"
    if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t "<C-p>", "n")
    elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(t "<Plug>luasnip-jump-prev", "")
    else
        fallback()
    end
end

M.setup = function()
    local fmt = string.format
    local cmp = require "cmp"

    -- require("cmp_nvim_lsp").setup()

    cmp.setup {
        completion = {
            -- autocomplete = true,
            completeopt = "menu,menuone,noinsert",
            keyword_length = 3,
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = {
            ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(shift_tab, { "i", "s" }),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            },
        },
        formatting = {
            format = function(entry, vim_item)
                -- vim_item.kind = fmt("%s %s", as.style.lsp.kinds[vim_item.kind], vim_item.kind)
                vim_item.menu = ({
                    nvim_lsp = "[L]",
                    emoji = "[Emoji]",
                    path = "[P]",
                    calc = "[C]",
                    luasnip = "[S]",
                    buffer = "[B]",
                })[entry.source.name]
                return vim_item
            end,
        },
        documentation = {
            border = vim.g.code_lsp_window_borders,
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
            { name = "nvim_lua" },
        },
    }
end

return M
