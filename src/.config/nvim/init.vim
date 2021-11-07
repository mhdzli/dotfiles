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
set bg=light

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
set wildmode=longest,list,full " enable autocompletion:
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

map <leader>n :Lexplore!<CR>
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
Plug 'lunarvim/colorschemes'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'rafamadriz/friendly-snippets'
Plug 'junegunn/goyo.vim'
Plug 'Yggdroot/indentLine'
Plug 'vim-scripts/indentpython.vim'
Plug 'kovetskiy/sxhkd-vim'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
Plug 'eparreno/vim-l9'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'mzlogin/vim-markdown-toc'
Plug 'lyokha/vim-xkbswitch'
call plug#end()
" --------------------------------------------------

""" lsp_config compe
lua << EOF
local nvim_lsp = require('lspconfig')

vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = false;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end


local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'bashls', 'clangd', 'cssls', 'html', 'jsonls', 'pylsp', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = '/home/mzeinali/.config/nvim/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/linux/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

EOF

" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>k <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" auto-format
autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 100)

" --------------------------------------------------

""" Goyo - makes text more readable when writing prose:
 map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
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

"  --- Auto Functions ----
" Run xrdb whenever Xdefaults or Xresources are updated.
 autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" Update binds when sxhkdrc is updated.
 autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
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

" Compile document, be it groff/LaTeX/markdown/etc.
" map <leader>c :w! \| !compiler <c-r>%<CR>

" Open corresponding .pdf/.html or preview
" map <leader>p :!opout <c-r>%<CR><CR>

" Update dwmbar when changed.
" autocmd BufWritePost *dwmbar !killall dwmbar; setsid dwmbar &

" When shortcut files are updated, renew bash and ranger configs with new material:
" autocmd BufWritePost *bmdirs,*bmfiles !shortcuts

" Automatically deletes all trailing whitespace on save.
" autocmd BufWritePre * %s/\s\+$//e
" --------------------------------------------------

