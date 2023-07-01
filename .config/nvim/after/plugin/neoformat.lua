--- Enable basic formatting when a filetype is not found. Disabled by default.

-- Enable alignment globally
vim.g.neoformat_basic_format_align = 1
--Enable tab to spaces conversion globally
vim.g.neoformat_basic_format_retab = 1
--Enable trimmming of trailing whitespace globally
vim.g.neoformat_basic_format_trim = 1

vim.g.neoformat_try_node_exe = 1

-- Run formatter on save
local fmt = vim.api.nvim_create_augroup("fmt", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "fmt",
  pattern = { "*.py", "*.js", "*.html", "*.ts", "*.css" },
  command = "undojoin | Neoformat",
})
