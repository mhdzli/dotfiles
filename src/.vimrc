let mapleader =","

" Auto install plugins
if ! filereadable(expand('~/.vim/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !mkdir -p ~/.vim/autoload/
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.vim/autoload/plug.vim
  autocmd VimEnter * PlugInstall
endif
" --------------------------------------------------

" --- Some basics ---
set title
set exrc " Enable reading .vimrc/.exrc/.gvimrc in the current directory
set nocompatible " Behave not very Vi
filetype plugin on " Enable loading the plugin files for specific file types
syntax enable " Switches on syntax highlighting
syntax on " Let Vim to overrule highlights with the defaults
set encoding=utf-8 " Character encoding used in Nvim: "utf-8"
set number relativenumber " Show the current line number and relative line numbers for other lines
set path+=** " Recursive file matching
set wildmenu " Tab auto completion in command mode
set wildmode=longest,list,full " enable autocompletion
set wildignorecase " disable case sensitivity in wild menu
set wildignore=\*.git/\*
set hidden " Don't unload a buffer when no longer shown in a window
set nowrap " Don't wrap long lines
set go=a " Make Visually highlighted text available for pasting into other applications
set mouse=a " Enable mouse support in all modes
set nohlsearch " Stop the highlighting for the 'hlsearch' option
set cursorline " Highlight the screen line of the cursor
set cursorcolumn " Highlight the screen column of the cursor
let &t_EI = "\e[2 q" " Block cursor in normal mode
let &t_SI = "\e[6 q" " Bar cursor in insert mode
set colorcolumn=80 " Highlight the 80th column of screen
set list lcs=tab:ᗕ-ᗒ,nbsp:⥣,trail:•,extends:⟩,precedes:⟨,multispace:⇝\ \ \ ,eol:↵
vnoremap . :normal .<CR> " Perform dot commands over visual blocks
set so=13 " Set scrolloff=13
set siso=13 " Set sidescrolloff=13
set pumheight=10 " Set the maximum height of the popup menu
"nnoremap c "_c
"autocmd InsertEnter * norm zz
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " disable automatic comment insertion

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

if empty($WAYLAND_DISPLAY)
  " Copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed):
  set clipboard=unnamedplus " Using system clipboard
  xnoremap <C-c> "+y
  nnoremap <C-p> "+P
  nnoremap <C-v> "*P
else
  xnoremap <C-c> y:call system("wl-copy", @")<cr>
  nnoremap <C-p> :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
  nnoremap <C-v> :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p
endif

" mark position before search
nnoremap / ms/

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
" It depends on 'wildcharm' being set to <C-z>
set wildcharm=<C-z>
cnoremap <expr> <Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>/<C-r>/' : '<C-z>'
cnoremap <expr> <S-Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>?<C-r>/' : '<S-Tab>'
" --------------------------------------------------

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
" --------------------------------------------------

" --- File Browser ---
""" Netrw
let g:netrw_banner=0 " Disable annoying banner
let g:netrw_browser_split=4 " Open in prior window
let g:netrw_altv=1 " Open splits to the right
let g:netrw_liststyle=3 " Tree view
let g:netrw_list_hide=netrw_gitignore#Hide() .. ',\(^\|\s\s\)\zs\.\S\+'

map <leader>n :Vexplore!<CR>
map <leader>N :Hexplore!<CR>
map <leader>E :Explore!<CR>
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
call plug#begin('.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'vimwiki/vimwiki'
Plug 'mzlogin/vim-markdown-toc'
Plug 'sainnhe/sonokai'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
call plug#end()
" --------------------------------------------------

""" VimWiki - Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
map <leader>v :VimwikiIndex<CR>
let g:vimwiki_list = [{'path': '~/.local/share/disroot/Notes', 'syntax': 'markdown', 'ext': '.md'}]
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex
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
" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre *.[ch] %s/\%$/\r/e
autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" --------------------------------------------------

" --- Theme ---
colorscheme sonokai

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
