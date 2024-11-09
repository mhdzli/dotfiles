local runner = require("util.telescope-runner").runner
local map = require("util.keymapper").map
local buf, win

local function open_win()
  buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

  local width = vim.api.nvim_get_option_value("columns", {})
  local height = vim.api.nvim_get_option_value("lines", {})

  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)

  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    title = "Code Runner Output",
    title_pos = "center",
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = "rounded",
  }

  win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_set_option_value("cursorline", true, { win = win })
  vim.api.nvim_set_option_value('winhl', 'FloatBorder:Comment,FloatTitle:Comment', { win = win })
end

local function view(command)
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
  vim.cmd("term " .. command)
  vim.api.nvim_buf_call(buf, function() vim.cmd("startinsert") end)
  vim.api.nvim_set_option_value("modifiable", false, { buf = 0 })
end


local function get_command(command_type)
  local file_type = vim.bo.filetype
  local file_path = vim.fn.expand("%:p")
  local file_name = vim.fn.expand("%:p:r")
  local file = vim.fn.expand("%")

  local commands = {
    build = {
      c = "g++ -std=c++17 -o " .. file_name .. ".o " .. file,
      cpp = "g++ -std=c++17 -Wall -O2 -o " .. file_name .. ".o " .. file,
      go = "go build",
      rust = "cargo build --release",
    },
    debug_build = {
      c = "g++ -std=c++17 -g -o " .. file_name .. ".o " .. file,
      cpp = "g++ -std=c++17 -g -o " .. file_name .. ".o " .. file,
      go = "go build",
      python = "python -m pdb " .. file_path,
      rust = "cargo build",
    },
    run = {
      bash = file_path,
      c = file_name .. ".o",
      cargo = "cd $dir && cargo run",
      cpp = file_name .. ".o",
      dart = "dart " .. file_path,
      go = "go run " .. file_path,
      html = "xdg-open " .. file_path,
      javascript = "js78 " .. file_path,
      lua = "lua " .. file_path,
      perl = "perl " .. file_path,
      php = "php " .. file_path,
      python = "python " .. file_path,
      r = "Rscript " .. file_path,
      ruby = "ruby " .. file_path,
      rust = "cargo run --release",
      sh = file_path,
      swift = "swift " .. file_path,
    },
  }

  if commands[command_type][file_type] ~= nil then
    return commands[command_type][file_type]
  else
    return nil
  end

end

vim.api.nvim_create_user_command("Build", function()
  local command = get_command("build") or "echo 'Command not defined'"
  open_win()
  view(command)
end, {})

vim.api.nvim_create_user_command("Debug", function()
  local command = get_command("debug_build") or "echo 'Command not defined'"
  open_win()
  view(command)
end, {})

vim.api.nvim_create_user_command("Run", function()
  local command = get_command("run") or "echo 'Command not defined'"
  open_win()
  view(command)
end, {})

vim.api.nvim_create_user_command("BuildRun", function()
  local command = get_command("build") or "echo 'Command not defined'"
  vim.cmd("!" .. command)
  vim.cmd([[Run]])
end, {})

vim.api.nvim_create_user_command("Config", function() vim.cmd([[cd ~/.config/nvim]]) end, {})

vim.api.nvim_create_user_command("UpdateAll", function()
  vim.cmd("Lazy sync")
  vim.cmd([[TSUpdateSync]])
  vim.cmd([[MasonUpdate]])
end, {})


map('<leader>r', function()
  runner(require("telescope.themes").get_dropdown {} )
end)
