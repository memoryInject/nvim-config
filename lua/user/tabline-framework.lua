local status_ok, tabline = pcall(require, "tabline_framework")
if not status_ok then
  return
end

local function color_hex(color)
  return '#' .. string.format("%06x", color)
end

-- debug values
local function _inspect(v)
  print(vim.inspect(v))
end

-- for redner current tab information at right side of tabline
local current_tab = {
  name = '',
  fg = 'None',
  bg = 'None',
  icon = { name = '', fg = 'None' },
  modified = '',
  is_modified = false
}

-- Get forground color set by color scheme
local tokyo_gray_color = '#3b4261'
local msg_area_color = color_hex(vim.api.nvim_get_hl_by_name("MsgArea", true).foreground)
local string_color = color_hex(vim.api.nvim_get_hl_by_name("String", true).foreground)
local function_color = color_hex(vim.api.nvim_get_hl_by_name("Function", true).foreground)
local cursor_color = color_hex(vim.api.nvim_get_hl_by_name("Cursor", true).foreground)

local render = function(f)

  -- _inspect(f)

  f.add { '  ', fg = msg_area_color, bg = tokyo_gray_color }
  f.add ' '
  f.make_tabs(function(info)
    -- get icon color assosiated with filetype (using nvim-web-devicons)
    local icon_color = f.icon_color(info.filename)

    -- If this is the current tab highlight it
    if info.current then
      -- We can use set_fg to change default fg color
      f.set_fg(cursor_color)
      current_tab.fg = cursor_color
      -- f.set_bg('None')
      if info.modified then
        f.set_bg(string_color)
        current_tab.bg = string_color
      else
        f.set_bg(function_color)
        current_tab.bg = function_color
      end
    end

    f.add(' ')

    if not info.modified then
      -- Tab number
      f.add { info.index }
      f.add(' ')
    end

    if info.filename then
      -- The icon function return a filetype icon based on the filename
      f.add(info.filename)
      f.add(' ')
      if info.current then
        f.add { f.icon(info.filename), fg = icon_color }
      else
        f.add { f.icon(info.filename) }
      end
    else
      -- [-] if the buffer has no name
      --or  [+] if it is also modified
      if info.modified then
        f.add { '[+]' }
      else
        f.add { '[-]' }
      end
    end


    if info.modified then
      -- + sign if the buffer is modified
      -- f.add(info.modified and ' ')
      f.add(' ')
      f.add { '' }
    end

    f.add(' ')

    if not info.current then
      f.add('')
    end
  end)

  -- Add a spacer which will justify the rest of the tabline to the right
  f.add_spacer()
  f.add('  ')

  -- Name of the current buffer, icon and colors.
  local buf_name = vim.api.nvim_buf_get_name(0)
  local filename = vim.fn.fnamemodify(buf_name, ":t")
  current_tab.name = filename
  local modified = vim.api.nvim_buf_get_option(0, 'modified')
  if modified then
    current_tab.modified = ''
    current_tab.is_modified = true
  else
    current_tab.modified = ''
    current_tab.is_modified = false
  end
  current_tab.icon.name = f.icon(filename)
  current_tab.icon.fg = f.icon_color(filename)

  f.add { ' ', bg = current_tab.bg }

  if current_tab.name == '' then
    if current_tab.is_modified then
      f.add { '[+]', bg = current_tab.bg, fg = current_tab.fg }
    else
      f.add { '[-]', bg = current_tab.bg, fg = current_tab.fg }
    end
  end

  f.add { current_tab.name, bg = current_tab.bg, fg = current_tab.fg }
  f.add { ' ', bg = current_tab.bg }
  f.add { current_tab.icon.name, bg = current_tab.bg, fg = current_tab.icon.fg }

  if current_tab.is_modified then
    f.add { ' ', bg = current_tab.bg }
    f.add { current_tab.modified, bg = current_tab.bg, fg = current_tab.fg }
  end

  f.add { ' ', bg = current_tab.bg }
  f.add { ' buffer ', bg = tokyo_gray_color, fg = function_color }

  -- Get current_tab_num/total_tab_count eg: 5/10 show in the right side
  local total_tab_count = tostring(#(vim.api.nvim_list_tabpages()))
  local current_tab_idx = tostring(vim.api.nvim_tabpage_get_number(0))

  -- display tab count and current tab index
  f.add { '  ',
    bg = function_color
  }
  f.add { 'tab ' .. current_tab_idx .. '/' .. total_tab_count,
    fg = cursor_color,
    bg = function_color
  }
  f.add { ' ',
    bg = function_color
  }
end

tabline.setup { render = render }
