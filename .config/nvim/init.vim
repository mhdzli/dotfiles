" let mapleader =","

set bg=light
set go=a
set mouse=a
set nohlsearch
set clipboard=unnamedplus
syntax enable

" Some basics:
"	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o


