let mapleader =","

" Auto install plugins
if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
 echo "Downloading junegunn/vim-plug to manage plugins..."
 silent !mkdir -p ~/.config/nvim/autoload/
 silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
 autocmd VimEnter * PlugInstall
endif
" --------------------------------------------------

" --- Theme ---
colorscheme mhl

" Set indent line color
 let g:indentLine_char = '┊'

" Highlight cursor line/position
"nnoremap <C-a> :set cursorline!<CR>
"nnoremap <C-f> :call HighlightNearCursor()<CR>
"function HighlightNearCursor()
"  if !exists("s:highlightcursor")
"    match Todo /\k*\%#\k*/
"    let s:highlightcursor=1
"  else
"    match None
"    unlet s:highlightcursor
"  endif
"endfunction
" --------------------------------------------------

" --- Some basics ---
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set number relativenumber
set path+=** " Recursive file matching
set wildmenu " Tab auto completion in command mode
" set wildmode=longest,full,full " enable autocompletion:
set hidden
set nowrap
set go=a
set mouse=a
set nohlsearch
set clipboard=unnamedplus
set cursorline
set cursorcolumn
set colorcolumn=80
vnoremap . :normal .<CR> " perform dot commands over visual blocks
" Set scrolloff=13
set so=13 
" Set sidescrolloff=13
set siso=13
"set list lcs=tab:\|\ 
"nnoremap c "_c
"autocmd InsertEnter * norm zz
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " disable automatic comment insertion

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed):
vnoremap <C-c> "+y
inoremap <C-p> "+P
inoremap <C-v> "+P

"enable copy and paste for vim in termux
if executable('termux-clipboard-set')
    vnoremap <C-x> :!termux-clipboard-set<CR>
    vnoremap <C-c> :w !termux-clipboard-set<CR><CR>
    inoremap <C-v> <ESC>:read !termux-clipboard-get<CR>i
endif

" Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>s :setlocal spell! spelllang=en_us<CR>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright

" Use <Tab>/<S-Tab> to move between matches without leaving incremental search.
" Note dependency on 'wildcharm' being set to <C-z> in order for this to
" work.
set wildcharm=<C-z>
cnoremap <expr> <Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>/<C-r>/' : '<C-z>'
cnoremap <expr> <S-Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>?<C-r>/' : '<S-Tab>'
" --------------------------------------------------

" --- File Browser ---
""" Netrw
let g:netrw_banner=0 " Disable annoying banner
let g:netrw_browser_split=4 " Open in prior window
let g:netrw_altv=1 " Open splits to the right
let g:netrw_liststyle=3 " Tree view
let g:netrw_lis_hide=netrw_gitignore#Hide()
let g:netrw_lis_hide.=',\(^\|\s\s\)\zs\.\S\+'

map <leader>n :Vexplore!<CR>
map <leader>N :Hexplore!<CR>

" --------------------------------------------------

" --- Indent ---
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab       " replace tabs with spaces
set smartindent     " do smart autoindenting when starting a new line
set autoindent      " copy indent when starting a new line

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2
" --------------------------------------------------

" --- Folding ---
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za
" --------------------------------------------------

" --- Flagging Unnecessary Whitespace ---
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
" --------------------------------------------------
" --- Plugins ---
call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'vimwiki/vimwiki'
Plug 'mzlogin/vim-markdown-toc'
Plug 'lyokha/vim-xkbswitch'
Plug 'nvim-lualine/lualine.nvim'
Plug 'lunarvim/colorschemes'

" LSP & cmp
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
" Plug 'hrsh7th/cmp-vsnip'
" Plug 'hrsh7th/vim-vsnip'

Plug 'rafamadriz/friendly-snippets', {'branch': 'main'}

" telescope requirements...
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" prettier
Plug 'sbdchd/neoformat'
call plug#end()
" --------------------------------------------------

set completeopt=menu,menuone,noselect

""" lsp_config nvim-cmp lualine
lua << EOF
require('lsp_config')
require('lualine_config')
EOF
" --------------------------------------------------

""" VimWiki - Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
 map <leader>v :VimwikiIndex<CR>
 let g:vimwiki_list = [{'path': '~/.local/share/nextcloud/Notes/linux', 'syntax': 'markdown', 'ext': '.md'}]
 autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
 autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
 autocmd BufRead,BufNewFile *.tex set filetype=tex
 nnoremap <C-x> f(yi(:!xdg-open <C-r>"<CR><CR>
" --------------------------------------------------

""" Xkb-switch
 let g:XkbSwitchEnabled = 1

""" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" --------------------------------------------------

""" Run formatter on save
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
" --------------------------------------------------

"  --- Run Codes ---

""" Python
if has('nvim')
        autocmd FileType python map <buffer> <leader>r :w<CR>:exec 'term python' shellescape(@%, 1)<CR>a
        autocmd FileType python imap <buffer> <leader>r <esc>:w<CR>:exec 'term python' shellescape(@%, 1)<CR>a
else
        autocmd FileType python map <buffer> <leader>r :w<CR>:exec '!clear && python' shellescape(@%, 1)<CR>
        autocmd FileType python imap <buffer> <leader>r <esc>:w<CR>:exec '!clear && python' shellescape(@%, 1)<CR>
endif
" --------------------------------------------------

" Automatically deletes all trailing whitespace on save.
" autocmd BufWritePre * %s/\s\+$//e
" --------------------------------------------------

