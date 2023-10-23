local cmap = require("util.keymapper").cmap

local config = function()
  local telescope = require('telescope')
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
        },
      },
    },
    pickers = {
      find_files = {
        theme = "dropdown",
        previewer = false,
        hidden = true,
      },
      live_grep = {
        theme = "dropdown",
        previewer = false,
      },
      buffers = {
        theme = "dropdown",
        previewer = false,
      },
      extensions = {
        fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
        },
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
      },
    },
  })
  telescope.load_extension('fzy_native')
  telescope.load_extension('undo')
end

return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzy-native.nvim",
    "debugloop/telescope-undo.nvim",
  },
  config = config,
  keys = {
    cmap('<leader>ff', 'Telescope find_files'),
    cmap('<leader>fg', 'Telescope live_grep'),
    cmap('<leader>fb', 'Telescope buffers'),
    cmap('<leader>fh', 'Telescope help_tags'),
    cmap('<leader>fc', 'Telescope command_history'),
    cmap('<leader>fo', 'Telescope oldfiles'),
    cmap('<leader>fa', 'Telescope grep_string'),
    cmap('<leader>fb', 'Telescope buffers'),
    cmap('<leader>f\'', 'Telescope marks'),
    cmap('<leader>f\"', 'Telescope registers'),
    cmap('<leader>fk', 'Telescope keymaps'),
    cmap('<leader>f/', 'Telescope current_buffer_fuzzy_find'),

    -- LSP Pickers
    cmap('<leader>fs', 'Telescope lsp_document_symbols'),
    cmap('<leader>fd', 'Telescope diagnostics'),
    cmap('<leader>fr', 'Telescope lsp_references'),
    cmap('<leader>fi', 'Telescope lsp_implementations'),
    cmap('<leader>fD', 'Telescope lsp_definitions'),
    cmap('<leader>ft', 'Telescope lsp_type_definitions'),

    -- Git Pickers
    cmap('<leader>fGc', 'Telescope git_commits'),
    cmap('<leader>fGC', 'Telescope git_bcommits'),
    cmap('<leader>fGb', 'Telescope git_branches'),
    cmap('<leader>fGs', 'Telescope git_status'),
    cmap('<leader>fGS', 'Telescope git_stash'),

    -- undo tree
    cmap('<leader>u', 'Telescope undo'),
  },
}
