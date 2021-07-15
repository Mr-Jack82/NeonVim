local M = {}

M.config = function()
    if as._default(vim.g.neon_treesitter_enabled) then
        require("nvim-treesitter.configs").setup {
            ensure_installed = vim.g.neon_treesitter_parsers_install or "maintained",
            ignore_install = vim.g.neon_treesitter_parsers_ignore or {},
            highlight = {
                enable = true, -- false will disable the whole extension
                use_languagetree = true,
            },
            indent = { enable = false },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
                    goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
                    goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
                    goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
                },
            },
        }
    end
end

return M
