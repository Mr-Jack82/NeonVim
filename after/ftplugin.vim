lua << EOF
-- check if option to set autocommand
as.check_and_set(vim.g.neon_highlight_yank, "TextYankPost", "*", 'lua require"vim.highlight".on_yank{timeout = 250}')
EOF

" Set filetypes
augroup Filetypes
  au!
  au BufNewFile,BufRead *.ejs,*.hbs set filetype=html
augroup END

" Terminal
augroup Terminal
    au!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * set nonumber norelativenumber
augroup END

" Format Options
augroup FmtOptions
    au!
    au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" Create missing directories when saving file
augroup Mkdir
    au!
    au BufWritePre * lua require'utils.extra'.mkdir()
augroup END
