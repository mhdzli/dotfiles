require('telescope').load_extension('fzy_native')
local map = require("keymap_module").map

map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
map('n', '<leader>fc', '<cmd>Telescope command_history<cr>')
map('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>')
map('n', '<leader>fa', '<cmd>Telescope grep_string<cr>')
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
map('n', '<leader>f\'', '<cmd>Telescope marks<cr>')
map('n', '<leader>f\"', '<cmd>Telescope registers<cr>')
map('n', '<leader>fk', '<cmd>Telescope keymaps<cr>')
map('n', '<leader>f/', '<cmd>Telescope current_buffer_fuzzy_find<cr>')

-- LSP Pickers
map('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<cr>')
map('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')
map('n', '<leader>fr', '<cmd>Telescope lsp_references<cr>')
map('n', '<leader>fi', '<cmd>Telescope lsp_implementations<cr>')
map('n', '<leader>fD', '<cmd>Telescope lsp_definitions<cr>')
map('n', '<leader>ft', '<cmd>Telescope lsp_type_definitions<cr>')

-- Git Pickers
map('n', '<leader>fGc', '<cmd>Telescope git_commits<cr>')
map('n', '<leader>fGC', '<cmd>Telescope git_bcommits<cr>')
map('n', '<leader>fGb', '<cmd>Telescope git_branches<cr>')
map('n', '<leader>fGs', '<cmd>Telescope git_status<cr>')
map('n', '<leader>fGS', '<cmd>Telescope git_stash<cr>')
