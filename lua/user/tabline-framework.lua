local status_lualine, _ = pcall(require, "lualine")
if not status_lualine then
  vim.notify('Can not find lualine!, tabline-framework disabled', vim.log.levels.WARN)
  return
end

local status_ok, tabline = pcall(require, "tabline_framework")
if not status_ok then
  return
end

local function color_hex(color)
  return '#' .. string.format("%06x", color)
end

local function color_hex_convert(hl_table)
  local color_table = {}
  for k, v in pairs(hl_table) do
    local status, hex_color = pcall(color_hex, v)
    if not status then
     hex_color = v
    end
     color_table[k] =  hex_color
  end
  return color_table
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

-- Get forground color set by color scheme `:hi` - to know all the colors
-- All the colors are tightly coupled with lualine 
local vim_icon_hi = color_hex_convert(vim.api.nvim_get_hl_by_name("lualine_b_normal", true))
local normal_hi = color_hex_convert(vim.api.nvim_get_hl_by_name("lualine_a_normal", true))
local insert_hi = color_hex_convert(vim.api.nvim_get_hl_by_name("lualine_a_insert", true))

local render = function(f)

  -- _inspect(f)

  -- vim icon
  f.add { '  ', fg = vim_icon_hi.foreground, bg = vim_icon_hi.background }

  f.make_tabs(function(info)
    -- get icon color assosiated with filetype (using nvim-web-devicons)
    local icon_color = f.icon_color(info.filename)

    -- If this is the current tab highlight it
    if info.current then
      -- We can use set_fg to change default fg color
      f.set_fg(normal_hi.foreground)
      current_tab.fg = normal_hi.foreground
      -- f.set_bg('None')
      if info.modified then
        f.set_bg(insert_hi.background)
        current_tab.bg = insert_hi.background
      else
        f.set_bg(normal_hi.background)
        current_tab.bg = normal_hi.background
      end
    end

    -- f.add(' ')

    -- if not info.modified then
    --   -- Tab number
    --   f.add { info.index }
    --   f.add(' ')
    -- end

    if info.filename then
      -- The icon function return a filetype icon based on the filename
      if info.current then
        f.add{' '}
        -- f.add { f.icon(info.filename) .. ' ', fg = normal_hi.foreground, bg = icon_color }
        f.add { f.icon(info.filename) .. ' ', fg = icon_color }
        f.add(info.filename .. ' ')
      else
        f.add(' ')
        f.add { f.icon(info.filename) .. ' '}
        f.add(info.filename .. ' ')
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
      -- f.add(' ')
      f.add { '' .. ' ' }
    end

    -- f.add{' ', bg = icon_color}
    -- f.add(' ')

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

  f.add { current_tab.icon.name, bg = current_tab.bg, fg = current_tab.icon.fg }
  f.add { ' ', bg = current_tab.bg }
  f.add { current_tab.name, bg = current_tab.bg, fg = current_tab.fg }
  -- f.add { current_tab.icon.name, bg = current_tab.bg, fg = current_tab.icon.fg }

  if current_tab.is_modified then
    f.add { ' ', bg = current_tab.bg }
    f.add { current_tab.modified, bg = current_tab.bg, fg = current_tab.fg }
  end

  f.add { ' ', bg = current_tab.bg }
  f.add { ' buffer ', bg = vim_icon_hi.background, fg = vim_icon_hi.foreground }

  -- Get current_tab_num/total_tab_count eg: 5/10 show in the right side
  local total_tab_count = tostring(#(vim.api.nvim_list_tabpages()))
  local current_tab_idx = tostring(vim.api.nvim_tabpage_get_number(0))

  -- display tab count and current tab index
  f.add { ' ',
    bg = insert_hi.background
  }
  f.add { 'tab ' .. current_tab_idx .. '/' .. total_tab_count,
    fg = insert_hi.foreground,
    bg = insert_hi.background
  }
  f.add { ' ',
    bg = insert_hi.background
  }
end

tabline.setup { render = render }
