"------------------------------------------------------------------------------
" Minor modification in default color nvim
"------------------------------------------------------------------------------

highlight clear
syntax reset

set bg=light

let g:colors_name="mhl"

hi ColorColumn        ctermbg=235          ctermfg=250
hi Comment            ctermbg=NONE         ctermfg=241      cterm=italic
hi CursorColumn       ctermbg=236          ctermfg=NONE
hi Cursor             ctermbg=NONE         ctermfg=NONE
hi CursorLine         ctermbg=237          cterm=bold
hi Debug              ctermbg=255          ctermfg=NONE
hi Delimiter          ctermbg=NONE         ctermfg=250
hi DiffAdd            ctermbg=NONE         ctermfg=255
hi DiffChange         ctermbg=NONE         ctermfg=700
hi DiffDelete         ctermbg=NONE         ctermfg=240
hi DiffText           ctermbg=NONE         ctermfg=250
hi FoldColumn         ctermbg=NONE         ctermfg=196
hi Folded             ctermbg=NONE         ctermfg=196
hi LineNr             ctermbg=NONE         ctermfg=249
hi MatchParen         ctermbg=NONE         ctermfg=70
hi ModeMsg            ctermbg=NONE         ctermfg=250
hi MoreMsg            ctermbg=NONE         ctermfg=250
hi NonText            ctermbg=NONE         ctermfg=240
hi Normal             ctermbg=NONE         ctermfg=255
hi Pmenu              ctermbg=NONE         ctermfg=255
hi PmenuSbar          ctermbg=NONE         ctermfg=70
hi PmenuSel           ctermbg=NONE         ctermfg=70
hi SignColumn         ctermbg=234          ctermfg=NONE
hi String             ctermbg=NONE         ctermfg=96
hi VertSplit          ctermbg=black        ctermfg=black
hi Visual             ctermbg=NONE         ctermfg=110      cterm=italic,bold
hi VisualNOS          ctermbg=NONE         ctermfg=7

hi def link diffCommon Statement
hi def link diffRemoved DiffDelet
hi def link diffChanged DiffChang
hi def link diffAdded DiffAdd
