local cmap = require("util.keymapper").cmap

return   {
  -- Edit file system in buffer
  "stevearc/oil.nvim",
  lazy = false,
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    view_options = {
      show_hidden = true,
    }
  },
  keys = {
    cmap('-', 'Oil'),
  },
}
