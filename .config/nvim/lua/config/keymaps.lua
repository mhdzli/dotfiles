local map = require("util.keymapper").map
local cmap = require("util.keymapper").cmap
-- local opt_toggle = require("util.keymapper").vim_opt_toggle

-- Better window navigation
map("<C-h>", "<C-w>h" )
map("<C-j>", "<C-w>j" )
map("<C-k>", "<C-w>k" )
map("<C-l>", "<C-w>l" )

-- Set keyboard layout to English when switch to normal mode
map("<ESC>", "<ESC>:silent! ![ -z '$WAYLAND_DISPLAY' ] && xkb-switch -s us || wkb-switch -s 0 && wkb-switch -b<CR><ESC>", "i")

-- mark position before search
map("/", "ms/")

-- Spell-check set to <leader>o, 'o' for 'orthography':
map("<leader>s", ":setlocal spell! spelllang=en_us<CR>", "")

-- Netrw
cmap("<leader>n", "Vexplore!", "")
cmap("<leader>N", "Hexplore!", "")
cmap("<leader>E", "Explore!", "")

-- Enable folding with the spacebar
map("<space>", "za")

-- Use <Tab>/<S-Tab> to move between matches without leaving incremental search.
map('<Tab>', function()
  local cmd_char = vim.fn.getcmdtype()
  return (cmd_char == '/' or cmd_char == '?') and '<C-g>' or '<Tab>'
end, "c", {expr = true})

map('<S-Tab>', function()
  local cmd_char = vim.fn.getcmdtype()
  return (cmd_char == '/' or cmd_char == '?') and '<C-t>' or '<S-Tab>'
end, "c", {expr = true})

if vim.api.nvim_win_get_option(0, "diff") then
  map("dp", "dp]c")
  map("do", "do]c")
end
