local status_lualine, _ = pcall(require, "lualine")
if not status_lualine then
  vim.notify("Can not find lualine!, tabline-framework disabled", vim.log.levels.WARN)
  return
end

local status_ok, tabline = pcall(require, "tabline_framework")
if not status_ok then
  return
end

local utils = require("user.tabline.utils")

-- for render current buffer information at right side of tabline
local current_buffer = {
  fg = "NONE",
  bg = "NONE",
}

-- Get forground color set by color scheme `:hi` - to know all the colors
-- All the colors are tightly coupled with lualine
local vim_icon_hi = utils.color_hex_convert(vim.api.nvim_get_hl_by_name("lualine_b_normal", true))
local normal_hi = utils.color_hex_convert(vim.api.nvim_get_hl_by_name("lualine_a_normal", true))
local insert_hi = utils.color_hex_convert(vim.api.nvim_get_hl_by_name("lualine_a_insert", true))

local render = function(f)
  -- Get current_tab_num/total_tab_count eg: 5/10 show in the right side
  local total_tab_count = tostring(#(vim.api.nvim_list_tabpages()))
  local current_tab_idx = tostring(vim.api.nvim_tabpage_get_number(0))

  -- vim icon
  f.add({ "  ", fg = vim_icon_hi.foreground, bg = vim_icon_hi.background })

  local paginate_info = utils.get_range_maxlen()
  local paginate = utils.get_pagination_pages(paginate_info.current, tonumber(total_tab_count), paginate_info.range)
  local buffer_list = utils.get_tab_buffer_list()
  local active_buf = 1
  for i, v in ipairs(buffer_list) do
    if v.current then
      active_buf = i
      break
    end
  end
  local paginate_buf = utils.get_pagination_pages(active_buf, #buffer_list, paginate_info.range)

  f.make_tabs(function(info)
    local tab_name = ""

    -- if the tab does not belong to paginate list
    -- make it hidden else make it visible
    info.hidden = true
    for _, v in ipairs(paginate) do
      if v == info.index then
        info.hidden = false
      end
    end

    if info.filename then
      tab_name = utils.shrink_string(info.filename, paginate_info.maxlen)
    end

    -- get icon color assosiated with filetype (using nvim-web-devicons)
    -- local icon_color = f.icon_color(info.filename)

    -- If this is the current tab highlight it
    if info.current then
      -- We can use set_fg to change default fg color
      f.set_fg(normal_hi.foreground)
      current_buffer.fg = normal_hi.foreground
      if info.modified then
        f.set_bg(insert_hi.background)
        current_buffer.bg = insert_hi.background
      else
        f.set_bg(normal_hi.background)
        current_buffer.bg = normal_hi.background
      end
    end

    if info.filename then
      -- The icon function return a filetype icon based on the filename
      if info.current then
        f.add({ " " })
        f.add(tab_name .. " ")
      else
        -- if the tab is hidden then render blank else render it's name
        if not info.hidden then
          f.add(" ")
          f.add(tab_name .. " ")
        end
      end
    else
      -- [-] if the buffer has no name
      --or  [+] if it is also modified
      if not info.hidden then
        if info.modified then
          f.add({ "[+]" })
        else
          f.add({ "[-]" })
        end
      end
    end

    if info.modified and not info.hidden then
      f.add({ "" .. " " })
    end

    if not info.current and not info.before_current then
      f.add("")
    end
  end)

  -- Add a spacer which will justify the rest of the tabline to the right
  f.add_spacer()
  f.add(" ")

  -- Name of the current buffer, icon and colors.
  local modified_icon = ""

  -- Loop through buffer list and add current tab buffers in to right side of the tabline
  for i, v in ipairs(buffer_list) do
    local name = utils.shrink_string(v.filename, paginate_info.maxlen)
    local hidden = true
    local first = i == 1 and true or false
    local last = i == #buffer_list and true or false

    if first and not v.current then
      f.add({ "", fg = "NONE" })
    end

    for _, val in ipairs(paginate_buf) do
      if val == i then
        hidden = false
      end
    end

    if v.current then
      name = utils.shrink_string(v.filename, paginate_info.maxlen + 3)
      if name ~= "" then
        f.add({ " " .. name .. " ", bg = current_buffer.bg, fg = current_buffer.fg })
        if v.modified then
          f.add({ modified_icon .. " ", bg = current_buffer.bg, fg = current_buffer.fg })
        end
      else
        if v.modified then
          f.add({ " [+] ", bg = current_buffer.bg, fg = current_buffer.fg })
        else
          f.add({ " [-] ", bg = current_buffer.bg, fg = current_buffer.fg })
        end
      end
    else
      if not hidden then
        if name ~= "" then
          f.add({ " " .. name .. " ", fg = "NONE" })
          if v.modified then
            f.add({ modified_icon .. " ", fg = "NONE" })
          end
        else
          if v.modified then
            f.add({ " [+] ", fg = "NONE" })
          else
            f.add({ " [-] ", fg = "NONE" })
          end
        end
      end
      if not v.before_current and not last then
        f.add({ "", fg = "NONE" })
      end
    end
  end

  f.add({ " buffer ", bg = vim_icon_hi.background, fg = vim_icon_hi.foreground })

  -- display tab count and current tab index
  f.add({ " ", bg = insert_hi.background })
  f.add({
    "tab " .. current_tab_idx .. "/" .. total_tab_count,
    fg = insert_hi.foreground,
    bg = insert_hi.background,
  })
  f.add({ " ", bg = insert_hi.background })
end

tabline.setup({ render = render })
