" Fix conflicts with Tim Pope's fugitive and avoid loading EditorConfig
" for any remote files over ssh
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" Fix conflicts of trailing whitespace trimming and buffer autosaving
let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']
