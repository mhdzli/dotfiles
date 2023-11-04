local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local runner = function(opts)
  opts = opts or {}

  pickers.new(opts, {
    finder = finders.new_table {
      results = { "Build", "Debug", "Run", "BuildRun" }

    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(bufnr, map)
      actions.select_default:replace(function()
        actions.close(bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd(selection[1])
      end)
      return true
    end,
  }):find()
end

return runner(require("telescope.themes").get_dropdown {})


