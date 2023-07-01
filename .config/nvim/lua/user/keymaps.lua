local map = require("keymap_module").map
local opt_toggle = require("keymap_module").vim_opt_toggle

-- Better window navigation
map("n", "<C-h>", "<C-w>h" )
map("n", "<C-j>", "<C-w>j" )
map("n", "<C-k>", "<C-w>k" )
map("n", "<C-l>", "<C-w>l" )

-- Set keyboard layout to English when switch to normal mode
map("i", "<ESC>", "<ESC>:silent! ![ -z '$WAYLAND_DISPLAY' ] && xkb-switch -s us || wkb-switch -s 0 && wkb-switch -b<CR><ESC>")

-- mark position before search
map("n", "/", "ms/")

-- Spell-check set to <leader>o, 'o' for 'orthography':
map("", "<leader>s", ":setlocal spell! spelllang=en_us<CR>")

-- Netrw
map("", "<leader>n", ":Vexplore!<CR>")
map("", "<leader>N", ":Hexplore!<CR>")
map("", "<leader>E", ":Explore!<CR>")

-- Enable folding with the spacebar
map("n", "<space>", "za")

-- Use <Tab>/<S-Tab> to move between matches without leaving incremental search.
map('c', '<Tab>', function()
  local cmd_char = vim.fn.getcmdtype()
  return (cmd_char == '/' or cmd_char == '?') and '<C-g>' or '<Tab>'
end, {expr = true})

map('c', '<S-Tab>', function()
  local cmd_char = vim.fn.getcmdtype()
  return (cmd_char == '/' or cmd_char == '?') and '<C-t>' or '<S-Tab>'
end, {expr = true})

if vim.api.nvim_win_get_option(0, "diff") then
  map("n", "dp", "dp]c")
  map("n", "do", "do]c")
end
