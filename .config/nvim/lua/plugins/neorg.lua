local cmap = require("util.keymapper").cmap
cmap("<leader>v", "Neorg index", "")

return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-cmp",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("neorg").setup {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
        ["core.integrations.nvim-cmp"] = {},
        ["core.keybinds"] = {
          -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
          config = {
            default_keybinds = true,
            neorg_leader = "<Leader><Leader>",
          },
        },
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
        ["core.esupports.metagen"] = { config = { type = "auto", update_date = true } },
        ["core.qol.toc"] = {},
        ["core.qol.todo_items"] = {},
        ["core.looking-glass"] = {},
        ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
        ["core.export"] = {},
        ["core.export.markdown"] = { config = { extensions = "all" } },
        ["core.summary"] = {},
      },
    }
    vim.wo.foldlevel = 99
    vim.wo.conceallevel = 2
  end,
}
