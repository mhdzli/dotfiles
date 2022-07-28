require("user")

-- Use <Tab>/<S-Tab> to move between matches without leaving incremental search.
-- Note dependency on 'wildcharm' being set to <C-z> in order for this to work.
vim.cmd([[
    set wildcharm=<C-z>
    cnoremap <expr> <Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>/<C-r>/' : '<C-z>'
    cnoremap <expr> <S-Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>?<C-r>/' : '<S-Tab>'
]])

-- disable automatic comment insertion
vim.cmd([[
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
]])
