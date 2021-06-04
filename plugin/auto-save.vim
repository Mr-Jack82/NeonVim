let g:auto_save        = 1
let g:auto_save_silent = 1
let g:auto_save_events = ["InsertLeave", "TextChanged", "FocusLost"]

" Disable auto save for javascript and json files
augroup ft_javascript
  au!
  au FileType javascript,json let b:auto_save = 0
augroup END
