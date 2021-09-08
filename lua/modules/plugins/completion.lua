local M = {}
local map = vim.api.nvim_set_keymap
local fn = vim.fn

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
end

local function tab(fallback)
    local luasnip = require "luasnip"
    if fn.pumvisible() == 1 then
        fn.feedkeys(t "<C-n>", "n")
    elseif luasnip.expand_or_jumpable() then
        fn.feedkeys(t "<Plug>luasnip-expand-or-jump", "")
    elseif check_back_space() then
        fn.feedkeys(t "<tab>", "n")
    else
        fallback()
    end
end

local function shift_tab(fallback)
    local luasnip = require "luasnip"
    if fn.pumvisible() == 1 then
        fn.feedkeys(t "<C-p>", "n")
    elseif luasnip.jumpable(-1) then
        fn.feedkeys(t "<Plug>luasnip-jump-prev", "")
    else
        fallback()
    end
end

-- symbols for autocomplete
local lsp_symbols = {
    Class = "   Class",
    Color = "   Color",
    Constant = "   Constant",
    Constructor = "   Constructor",
    Enum = " ❐  Enum",
    EnumMember = "   EnumMember",
    Event = "   Event",
    Field = " ﴲ  Field",
    File = "   File",
    Folder = "   Folder",
    Function = "   Function",
    Interface = " ﰮ  Interface",
    Keyword = "   Keyword",
    Method = "   Method",
    Module = "   Module",
    Operator = "   Operator",
    Property = "   Property",
    Reference = "   Reference",
    Snippet = " ﬌  Snippet",
    Struct = " ﳤ  Struct",
    Text = "   Text",
    TypeParameter = "   TypeParameter",
    Unit = "   Unit",
    Value = "   Value",
    Variable = "[] Variable",
}

M.setup = function()
    local cmp = require "cmp"

    -- require("cmp_nvim_lsp").setup()

    cmp.setup {
        completion = {
            autocomplete = as._default(vim.g.code_autocomplete),
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
            format = function(entry, item)
                item.kind = lsp_symbols[item.kind]
                item.menu = ({
                    nvim_lsp = "[L]",
                    path = "[P]",
                    calc = "[C]",
                    luasnip = "[S]",
                    buffer = "[B]",
                    spell = "[Spell]",
                })[entry.source.name]
                return item
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
            { name = "spell" },
        },
    }

    vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>luasnip-expand-or-jump", { silent = true })
    vim.api.nvim_set_keymap(
        "i",
        "<C-k>",
        "<cmd>lua require('luasnip').jump(-1)<Cr>",
        { silent = true }
    )
end

return M
