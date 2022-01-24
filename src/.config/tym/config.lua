-- At first, you need to require tym module
local tym = require('tym')
local home = os.getenv('HOME')

-- set individually
tym.set('width', 100)

tym.set('font', 'Monospace 14')

-- set by table
tym.set_config({
  shell = '/usr/bin/zsh',
  cursor_blink_mode = 'on',
  cursor_shape = 'block',
  autohide = true,
  silent = true,
  title = 'tym',
  color_foreground = 'white',
  color_background = 'rgba(16, 16, 16, 0.95)',
})

local function update_scale(delta)
  local old_value = tym.get('scale')
  local new_value = math.max(math.min(1000, old_value + delta), 30)
  tym.set('scale', new_value)
  tym.notify(string.format('scale: %d → %d', old_value, new_value))
end

-- my implementation since the `scale` wasn't mentioned in documents
--[[
function update_scale(delta)
  local current_font = tym.get('font')
  local font_size = string.match(current_font, "%d+")
  current_font = current_font:gsub("%d+",  font_size + delta)
  tym.set('font', current_font)
  tym.notify('Increasing font size')
end
]]--

local function update_alpha(delta)
  local r, g, b, old_alpha = tym.color_to_rgba(tym.get('color_background'))
  local new_alpha = math.max(math.min(1.0, old_alpha + delta), 0.0)
  local new_bg = tym.rgba_to_color(r, g, b, new_alpha)
  tym.set('color_background', new_bg)
  tym.notify(string.format('Alpha: %f → %f', old_alpha, new_alpha))
end

tym.set_keymap('<Ctrl>equal', function()
  update_scale(10)
end)
tym.set_keymap('<Ctrl>minus', function()
  update_scale(-10)
end)

--new

local function remap(a, b)
  tym.set_keymap(a, function()
    tym.send_key(b)
  end)
end

local function safe_dofile(path)
  local f = io.open(path, 'r')
  if f ~= nil then
    io.close(f)
    dofile(path)
  end
end

tym.set_keymaps({
  ['<Ctrl><Shift>r'] = function()
    tym.reload()
    tym.notify('Reloaded')
  end,
  ['<Ctrl><Shift>u'] = function()
    tym.reset_config()
    tym.reload()
    tym.notify('Reset and Reloaded')
  end,
  ['<Ctrl>equal'] = function()
    update_scale(10)
  end,
  ['<Ctrl>minus'] = function()
    update_scale(-10)
  end,
  ['<Ctrl>slash'] = function()
    update_alpha(0.05)
  end,
  ['<Ctrl>period'] = function()
    update_alpha(-0.05)
  end,
  ['<Ctrl><Shift>g'] = function()
    tym.set_timeout(coroutine.wrap(function()
      tym.send_key('<Alt>t')
      coroutine.yield(true)
      tym.send_key('<Ctrl>g')
      coroutine.yield(true)
      tym.send_key('<Ctrl>m')
      coroutine.yield(false)
    end), 100)
  end,
  ['<Ctrl><Shift>plus'] = function()
    tym.set('scale', 100)
    local r, g, b, old_alpha = tym.color_to_rgba(tym.get('color_background'))
    tym.set('color_background', tym.rgba_to_color(r, g, b, 1))
    tym.notify('Reset alpha and scale')
  end
})

tym.set_hooks({
  scroll = function(dx, dy, x, y)
    if tym.check_mod_state('<Ctrl>') then
      update_scale(dy < 0 and 10 or -10)
      return true
    end
    if tym.check_mod_state('<Shift>') then
      update_alpha(dy < 0 and 0.05 or -0.05)
      return true
    end
  end
})

remap('<Alt>h', '<Alt>Left')
remap('<Alt>l', '<Alt>Right')
remap('<Alt><Shift>h', '<Alt><Shift>Left')
remap('<Alt><Shift>l', '<Alt><Shift>Right')
remap('<Ctrl>Tab', '<Ctrl>n')
remap('<Ctrl><Shift>Tab', '<Ctrl>p')

safe_dofile(home .. '/.config/tym/local.lua')
