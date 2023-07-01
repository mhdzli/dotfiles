vim.g.mapleader = ","

-- File Browser
-- Netrw
vim.g.netrw_banner = 0 -- Disable annoying banner
vim.g.netrw_browser_split = 4 -- Open in prior window
vim.g.netrw_altv = 1 -- Open splits to the right
vim.g.netrw_liststyle = 3 -- Tree view
-- vim.g.netrw_list_hide = '\\..*'
-- vim.cmd([[
-- let g:netrw_list_hide=netrw_gitignore#Hide() .. ',\(^\|\s\s\)\zs\.\S\+'
-- ]])

-- Global options

local options = {
  fileencoding = "utf-8", -- Character encoding used in Nvim: "utf-8"
  exrc = true, -- Enable reading .vimrc/.exrc/.gvimrc in the current directory
  -- nocompatible = true, -- Behave not very Vi. Nvim is always "nocompatible"

  wildmenu = true, -- Tab auto completion in command mode
  wildmode = "longest:full,full", -- enable autocompletion
  wildignore = { "*.git/*", ".git", ".hg", ".svn", "*.pyc", "*.o", "*.out", "*.jpg", "*.jpeg", "*.png", "*.gif", "*.zip", "**/node_modules/**", "**/bower_modules/**", "__pycache__", "*~", "*.DS_Store", "**/undo/**", "*[Cc]ache/" },
  wildignorecase = true, -- disable case sensitivity in wild menu

  --completeopt = "menu,menuone,noselect",
  completeopt = { "menuone", "noselect"},

  hidden = true, -- Don't unload a buffer when no longer shown in a window
  wrap = false, -- Don't wrap long lines
  hlsearch = false, -- Stop the highlighting for the 'hlsearch' option
  -- These highlights are being handled by an autocmd on WinEnter/Leave in highlights.lua
  colorcolumn = "80", -- highlight given column
  cursorcolumn = true, -- Highlight the screen column of the cursor
  cursorline = true, -- Highlight the screen line of the cursor

  syntax = "Enable", -- Switches on syntax highlighting and Let Vim to overrule highlights with the defaults

  so = 13, -- Set scrolloff=13
  siso = 13, -- Set sidescrolloff=13
  pumheight = 10, -- Set the maximum height of the popup menu
  nu = true,
  relativenumber = true,

  go = "a", -- Make Visually highlighted text available for pasting into other applications
  mouse = "a", -- Enable mouse support in all modes

  -- Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
  splitright = true,
  splitbelow = true,
  backup = false, -- creates a backup file
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  -- cmdheight = 0,
  confirm = true, -- confirm before closing unsaved file

  -- fold options
  foldcolumn = "0", -- fold column
  fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
  foldmethod = "indent",
  foldlevel = 99,
  foldopen = vim.opt.foldopen + "jump", -- When jumping to the line auto-open the folder

  laststatus = 3,
  virtualedit = "none", -- Position cursor everywhere
  -- There's a mapping to toggle this in 'functions.lua', i.e. `:V`
  -- timeoutlen = 250,

  -- path = vim.opt.path + "~/.config/nvim/lua/user",
  path = vim.opt.path + "**", -- Recursive file matching

  -- Tab Handling:
  expandtab = true, -- Replace tabs with spaces
  shiftwidth = 4,
  softtabstop = 4,
  tabstop = 4,
  smartindent = true, -- Do smart autoindenting when starting a new line
  autoindent = true, -- Copy indent when starting a new line
  shiftround = true,
  showmode = false,

  formatoptions = vim.opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2", -- I'm not in gradeschool anymore

  termguicolors = true, -- default is false

  -- Undofile
  undodir = vim.fn.stdpath('data')..'/undodir',
  undofile = true,
  undoreload = 10000,
  updatetime = 300,
  inccommand = "nosplit", -- split shows substitutions in a preview window
  -- search
  ignorecase = true,
  smartcase = true, -- only works with ingnorecase = true

  -- Change directory to the current file's directory
  autochdir = true,

  listchars = {eol = '↵', multispace = '⇝   ', tab = 'ᗕ-ᗒ', nbsp = '⥣', trail = '•', extends = '⟩' , precedes = '⟨',},
  list = true,

  -- tw = 79, -- width of document
  -- linebreak = true,
}

for k, v in pairs(options) do -- for key, value pair, let...
  vim.opt[k] = v
end
