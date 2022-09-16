local status_ok, tabline = pcall(require, "tabline_framework")
if not status_ok then
  return
end

local function color_hex(color)
  return '#' .. string.format("%06x", color)
end

local render = function(f)
  -- Get forground color set by color scheme
  local msg_area_color = color_hex(vim.api.nvim_get_hl_by_name("MsgArea", true).foreground)
  local string_color = color_hex(vim.api.nvim_get_hl_by_name("String", true).foreground)
  local function_color = color_hex(vim.api.nvim_get_hl_by_name("Function", true).foreground)
  local cursor_color = color_hex(vim.api.nvim_get_hl_by_name("Cursor", true).foreground)

  f.add { ' ', fg = msg_area_color }
  f.add ' '
  f.make_tabs(function(info)
    -- get icon color assosiated with filetype (using nvim-web-devicons)
    local icon_color = f.icon_color(info.filename)

    -- If this is the current tab highlight it
    if info.current then
      -- We can use set_fg to change default fg color
      f.set_fg(msg_area_color)
      f.set_bg('None')
    end

    f.add(' ')

    if not info.modified then
      -- Tab number
      f.add { info.index }
      f.add(' ')
    end

    if info.filename then
      -- The icon function return a filetype icon based on the filename
      if info.current then
        f.add { f.icon(info.filename), fg = icon_color }
      else
        f.add { f.icon(info.filename) }
      end
      f.add(' ')
      f.add(info.filename)
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
      if info.current then
        f.add { '', fg = string_color }
      else
        f.add { '' }
      end
    end


    if not info.current then
      f.add(' ')
    else
      f.add { ' |', fg = msg_area_color }
    end
  end)

  -- Add a spacer which will justify the rest of the tabline to the right
  f.add_spacer()

  -- Get current_tab_num/total_tab_count eg: 5/10 show in the right side
  local total_tab_count = tostring(#(vim.api.nvim_list_tabpages()))
  local current_tab_idx = tostring(vim.api.nvim_tabpage_get_number(0))

  -- display tab count and current tab index
  f.add { ' ',
    fg = function_color
  }
  f.add { current_tab_idx .. '/' .. total_tab_count,
    fg = cursor_color,
    bg = function_color
  }
  f.add { '',
    fg = function_color
  }
end

tabline.setup { render = render }
