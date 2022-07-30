vim.g.vimwiki_list = {
    {
        path = '~/.local/share/disroot/Notes',
        syntax = 'markdown',
        ext = '.md',
    }
}
vim.g.vimwiki_ext2syntax = {
    ['.md'] = 'markdown',
    ['.markdown'] = 'markdown',
    ['.mdown'] = 'markdown',
    ['.Rmd'] = 'markdown',
    ['.rmd'] = 'markdown',
}

local map = require("keymap_module").map
map("", "<leader>v", ":VimwikiIndex<CR>")
