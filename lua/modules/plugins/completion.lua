local M = {}
local api = vim.api
local feedkeys = api.nvim_feedkeys

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

local function t(str)
    return api.nvim_replace_termcodes(str, true, true, true)
end

local has_words_before = function()
    local cursor = api.nvim_win_get_cursor(0)
    return not api.nvim_get_current_line():sub(1, cursor[2]):match "^%s$"
end

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
            ["<Tab>"] = cmp.mapping(function(fallback)
                local luasnip = require "luasnip"
                if vim.fn.pumvisible() == 1 then
                    feedkeys(t "<C-n>", "n", true)
                elseif has_words_before() and luasnip.expand_or_jumpable() then
                    feedkeys(t "<Plug>luasnip-expand-or-jump", "", true)
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),
            ["<S-Tab>"] = cmp.mapping(function()
                local luasnip = require "luasnip"
                if vim.fn.pumvisible() == 1 then
                    feedkeys(t "<C-p>", "n", true)
                elseif luasnip.jumpable(-1) then
                    feedkeys(t "<Plug>luasnip-jump-prev", "", true)
                end
            end, {
                "i",
                "s",
            }),
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

    local map = api.nvim_set_keymap
    map("i", "<C-j>", "<Plug>luasnip-expand-or-jump", { silent = true })
    map("i", "<C-k>", "<cmd>lua require('luasnip').jump(-1)<Cr>", { silent = true })
end

M.autopairs = function()
    if as._default(vim.g.code_autopairs) then
        local pairs = require "nvim-autopairs"
        local Rule = require "nvim-autopairs.rule"
        local cond = require "nvim-autopairs.conds"
        local endwise = require("nvim-autopairs.ts-rule").endwise

        pairs.setup {
            check_ts = true,
        }
        require("nvim-autopairs.completion.cmp").setup {
            map_cr = true, --  map <CR> on insert mode
            map_complete = false, -- it will auto insert `(` after select function or method item
            auto_select = false, -- automatically select the first item
        }

        -- Custom rules
        pairs.add_rules {
            -- Add spaces between parentheses when pressing <space>
            Rule(" ", " ")
                :with_pair(function(opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    return vim.tbl_contains({ "()", "{}", "[]" }, pair)
                end)
                :with_move(cond.none())
                :with_cr(cond.none())
                :with_del(function(opts)
                    local col = vim.api.nvim_win_get_cursor(0)[2]
                    local context = opts.line:sub(col - 1, col + 2)
                    return vim.tbl_contains({ "(  )", "{  }", "[  ]" }, context)
                end),
            Rule("", " )")
                :with_pair(cond.none())
                :with_move(function(opts)
                    return opts.char == ")"
                end)
                :with_cr(cond.none())
                :with_del(cond.none())
                :use_key ")",
            Rule("", " }")
                :with_pair(cond.none())
                :with_move(function(opts)
                    return opts.char == "}"
                end)
                :with_cr(cond.none())
                :with_del(cond.none())
                :use_key "}",
            Rule("", " ]")
                :with_pair(cond.none())
                :with_move(function(opts)
                    return opts.char == "]"
                end)
                :with_cr(cond.none())
                :with_del(cond.none())
                :use_key "]",
            -- arrow key on javascript, typescript
            Rule(
                "%(.*%)%s*%=>$",
                " {}",
                { "typescript", "typescriptreact", "javascript", "javascriptreact" }
            ):use_regex(true):set_end_pair_length(1),
            -- endwise
            endwise("then$", "end", "lua", nil),
            endwise("function%(.*%)$", "end", "lua", nil),
            endwise("do$", "end", "lua", nil),
        }
    end
end

return M
