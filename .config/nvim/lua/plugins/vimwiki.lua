return   {
  "vimwiki/vimwiki",
  init = function()
    vim.g.vimwiki_list = {
      {path = '~/.local/share/disroot/Notes',
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
  end,
}
