return {
  -- mdlink
  'Nedra1998/nvim-mdlink',
  config = function()
    require('nvim-mdlink').setup({
      keymap = true,
      cmp = true
    })
  end

}
