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
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'rafamadriz/friendly-snippets', {'branch': 'main'}
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'onsails/lspkind-nvim'
Plug 'junegunn/goyo.vim'
Plug 'Yggdroot/indentLine'
Plug 'vim-scripts/indentpython.vim'
Plug 'kovetskiy/sxhkd-vim'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
Plug 'eparreno/vim-l9'
Plug 'vim-airline/vim-airline'
Plug 'mzlogin/vim-markdown-toc'
Plug 'lyokha/vim-xkbswitch'
call plug#end()
" --------------------------------------------------

set completeopt=menu,menuone,noselect

""" lsp_config compe
lua << EOF
-- Set completeopt to have a better completion experience

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'pyright', 'bashls', 'clangd', 'cssls', 'html', 'jsonls', 'pylsp', 'tsserver', 'vimls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end,
  },
  experimental = {
    ghost_text = true,
    native_menu = false,
  },
  formatting = {
    format = require("lspkind").cmp_format({with_text = true, menu = ({
      buffer = "[Buffer]",
      nvim_lsp = "[LSP]",
      luasnip = "[LuaSnip]",
      vsnip = "[VSnip]",
      nvim_lua = "[Lua]",
      latex_symbols = "[Latex]",
    })}),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
}

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

