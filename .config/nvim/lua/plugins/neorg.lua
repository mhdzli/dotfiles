local cmap = require("util.keymapper").cmap
cmap("<leader>v", "Neorg index", "")

return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("neorg").setup {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {
          config = {
            icons = {
              heading = { 
                -- icons = { "❂", "✺", "◉", "⌾", "⨀", "○" },
                -- icons = { "", "", "", "✺", "", "" },
                -- icons = { "❶", "❷", "❸", "❹", "❺", "❻" },
                -- icons = { "◉", "◎", "○", "✺", "▶", "⤷" }, --default
              },
              ordered = {
                -- icons = (not has_anticonceal) and { "1", "A", "①", "a", "1", "A" } or nil
                -- icons = (not has_anticonceal) and { "⒈", "A", "a", "⑴", "Ⓐ", "ⓐ" } or nil, --default
              },
            },
          },
        }, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/.local/share/disroot/neorg",
              linux = "~/.local/share/disroot/neorg/linux",
              gen = "~/.local/share/disroot/neorg/general",
              mtv = "~/.local/share/disroot/neorg/movies-tvs-anime",
              psh = "~/.local/share/disroot/neorg/powershell",
              fun = "~/.local/share/disroot/neorg/fun",
              eng = "~/.local/share/disroot/neorg/english-learning",
            },
            default_workspace = "notes",
          },
        },
      },
    }
    vim.wo.foldlevel = 99
    vim.wo.conceallevel = 2
  end,
}
