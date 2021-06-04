" Disable default mappings
" let g:EasyMotion_do_mapping = 0

" Setting up <Leader> key for easymotion
" Note: This mapping conflicts with which-key.nvim"
" map <Leader> <Plug>(easymotion-prefix)

" Jump to anywhere you want with minimal keystrokes, with just one key
" binding. `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)

" Bidirectional & within line 't' motion
omap t <Plug>(easymotion-bd-tl)

" Enable 'dot' repeat feature
omap z <Plug>(easymotion-t)
let g:EasyMotion_keys='hklyuiopnm,qwertzxcvbasdgjf;'

" Lazy targeting
let g:EasyMotion_smartcase = 1

" Use uppercase target labels and type as a lower case
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;'
