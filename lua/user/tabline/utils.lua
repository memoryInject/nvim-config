local M = {}

M.color_hex = function(color)
  return "#" .. string.format("%06x", color)
end

M.color_hex_convert = function(hl_table)
  local color_table = {}
  for k, v in pairs(hl_table) do
    local status, hex_color = pcall(M.color_hex, v)
    if not status then
      hex_color = v
    end
    color_table[k] = hex_color
  end
  return color_table
end

M.get_tab_list = function()
  local tabs = vim.api.nvim_list_tabpages()
  local tab_list = {}
  for i, v in ipairs(tabs) do
    local current_tab = vim.api.nvim_get_current_tabpage()
    local current = current_tab == v

    local win = vim.api.nvim_tabpage_get_win(v)
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local filename = vim.fn.fnamemodify(buf_name, ":t")
    local modified = vim.api.nvim_buf_get_option(buf, "modified")

    local tab_info = {
      before_current = tabs[i + 1] and tabs[i + 1] == current_tab,
      after_current = tabs[i - 1] and tabs[i - 1] == current_tab,
      first = i == 1,
      last = i == #tabs,
      index = i,
      tab = v,
      current = current,
      win = win,
      buf = buf,
      buf_nr = buf,
      buf_name = buf_name,
      filename = #filename > 0 and filename or nil,
      modified = modified,
    }

    table.insert(tab_list, tab_info)
  end

  return tab_list
end

M.get_filenames = function(list)
  local filenames = {}

  for _, v in ipairs(list) do
    table.insert(filenames, v.filename)
  end

  return filenames
end

M.get_tab_list_names = function()
  return M.get_filenames(M.get_tab_list())
end

M.get_tab_list_full = function()
  local tabnrs = vim.api.nvim_list_tabpages()
  local current_win = vim.api.nvim_get_current_win()
  local tab_windows = {}

  local idx = 0

  local tablist = M.get_tab_list()

  for tabidx, tabnr in ipairs(tabnrs) do
    -- Get the windows of this tab
    local windownrs = vim.api.nvim_tabpage_list_wins(tabnr)
    for windownr, windowid in ipairs(windownrs) do
      idx = idx + 1
      local current = false
      if windowid == current_win then
        -- found the current window
        current = true
      end

      -- the bufnr
      local bufnr = vim.api.nvim_win_get_buf(windowid)

      -- check the buftype
      -- if it's not empty then don't include it
      local buftype = vim.fn.getbufvar(bufnr, "&buftype")

      if buftype == "" then
        local info = vim.fn.getbufinfo(bufnr)[1]
        local file_name = nil
        local active = false

        if info.name then
          file_name = vim.fn.fnamemodify(info.name, ":t")
          for _, v in ipairs(tablist) do
            if v.filename == file_name then
              active = true
            end
          end
        end

        local element = {
          tabnr = tabnr,
          tabidx = tabidx,
          windownr = windownr,
          windowid = windowid,
          path = info.name,
          bufnr = info.bufnr,
          windows = info.windows,
          filename = #file_name > 0 and file_name or nil,
          active = active,
          current = current,
        }
        table.insert(tab_windows, element)
      end
    end
  end

  return tab_windows
end

M.get_tab_list_full_names = function()
  return M.get_filenames(M.get_tab_list_full())
end

M.get_tab_buffer_list = function()
  local tablist_full = M.get_tab_list_full()
  local current_tab_idx = nil
  local buffer_list = {}

  for _, v in ipairs(tablist_full) do
    if v.current == true then
      current_tab_idx = v.tabidx
      break
    end
  end

  for _, v in ipairs(tablist_full) do
    if v.tabidx == current_tab_idx then
      table.insert(buffer_list, v)
    end
  end

  for i, v in ipairs(buffer_list) do
    local modified = vim.api.nvim_buf_get_option(v.bufnr, "modified")
    local before_current = buffer_list[i + 1] and buffer_list[i + 1].current == true
    local after_current = buffer_list[i - 1] and buffer_list[i - 1].current == true

    v.modified = modified and true or false
    v.before_current = before_current and true or false
    v.after_current = after_current and true or false
  end

  return buffer_list
end

M.get_tab_buffer_list_names = function()
  return M.get_filenames(M.get_tab_buffer_list())
end

M.get_current_buffer = function()
  for _, v in ipairs(M.get_tab_buffer_list()) do
    if v.current == true then
      return v
    end
  end

  return nil
end

M.get_tab_buffer_combined_list = function()
  local tablist = M.get_tab_list()
  for _, v in ipairs(M.get_tab_buffer_list()) do
    table.insert(tablist, v)
  end
  return tablist
end

M.get_tab_buffer_combined_list_names = function()
  local tabnames = M.get_tab_list_names()
  for _, v in ipairs(M.get_tab_buffer_list_names()) do
    table.insert(tabnames, v)
  end
  return tabnames
end

M.shrink_string = function(str, max_len)
  if max_len < 4 then
    max_len = 4
  end

  if str ~= nil and #str > max_len then
    return str:sub(1, math.ceil(max_len - 3)) .. "..."
  else
    if str ~= nil then
      return str
    end
    return ""
  end
end

M.get_pagination_pages = function(current_page, total_pages, range)
  -- Initialize the list of pages to display
  local pages = {}

  -- Add the first page to the list
  table.insert(pages, 1)

  -- If the current page is within the first range pages, don't add any ellipses at the beginning
  if current_page > range and current_page > range + 1 and current_page ~= range + 2 then
    table.insert(pages, "...")
  end

  -- Add the current page and the range number of pages before and after it
  for i = current_page - range, current_page + range do
    if i > 1 and i < total_pages then
      table.insert(pages, i)
    end
  end

  -- If the current page is within the last range pages, don't add any ellipses at the end
  if current_page < total_pages - range and total_pages ~= current_page + range + 1 then
    table.insert(pages, "...")
  end

  -- Add the last page to the list
  table.insert(pages, total_pages)

  -- Return the list of pages
  return pages
end

M.get_ellipses_index = function(pagination_array)
  local start_ellips = 0
  local end_ellips = 0

  for i, v in ipairs(pagination_array) do
    if start_ellips == 0 and v == "..." then
      start_ellips = i
    end

    if start_ellips ~= 0 and v == "..." then
      -- check the previous value then add one.
      if pagination_array[i - 1] ~= "..." then
        end_ellips = pagination_array[i - 1] + 1
      end
    end
  end

  return start_ellips, end_ellips
end

M.iter = 0

M.reset_iter = function()
  M.iter = 0
end

M.ratio = 1.2

-- Find the right range for pagination and max_len for shrink_string
M.re_paginate = function(tab_names, page_range, current_page, win_width, tab_width, max_len)
  M.iter = M.iter + 1
  local ratio = win_width / tab_width

  if ratio > M.ratio or M.iter > 90 or page_range < 0 then
    return {
      names = tab_names,
      range = page_range < 0 and 0 or page_range,
      width = tab_width,
      maxlen = max_len,
      iter = M.iter,
      current = current_page,
    }
  end

  local page_array = M.get_pagination_pages(current_page, #tab_names, page_range)
  local filter_tab_names = {}
  for i, v in ipairs(page_array) do
    if tab_names[v] then
      table.insert(filter_tab_names, tab_names[v])
    else
      table.insert(filter_tab_names, i, v)
    end
  end

  tab_width = 0
  for _, v in ipairs(filter_tab_names) do
    tab_width = tab_width + #v + 3
  end

  -- Check if we get new ratio with filter_tab_names with pagination
  ratio = win_width / tab_width
  if ratio > M.ratio then
    return {
      names = filter_tab_names,
      range = page_range,
      width = tab_width,
      maxlen = max_len,
      iter = M.iter,
      current = current_page,
    }
  end

  -- try to shrink tab names before next recursion
  local shrinked_tab_names = {}
  for _, v in ipairs(tab_names) do
    table.insert(shrinked_tab_names, M.shrink_string(v, max_len))
  end

  return M.re_paginate(shrinked_tab_names, page_range - 1, current_page, win_width, tab_width, max_len - 1)
end

M.max_len = 21     -- initial max_len for shrink_string
M.extra_space = 21 -- extra details on the tabline that took some spaces

M.get_range_maxlen = function()
  -- local win_width = vim.fn.winwidth(0) - M.extra_space -- get the width of window
  local win_width = vim.o.columns - M.extra_space -- get the width of window
  local tabnames = M.get_tab_buffer_combined_list_names()
  local current_tab_idx = M.get_current_buffer() and M.get_current_buffer().tabidx or 1
  local tab_width = 0
  for _, v in ipairs(tabnames) do
    tab_width = tab_width + #v + 3
  end

  M.reset_iter()

  return M.re_paginate(tabnames, #tabnames, current_tab_idx, win_width, tab_width, M.max_len)
end

M.tabmove_next = function()
  local tablist_full = M.get_tab_list_full()
  local total_tabs = #vim.api.nvim_list_tabpages()
  local current_tab_idx = nil
  for _, v in ipairs(tablist_full) do
    if v.current == true then
      current_tab_idx = v.tabidx
      break
    end
  end
  if current_tab_idx == total_tabs then
    vim.cmd.tabmove()
    vim.cmd.tabmove(0)
  else
    vim.cmd.tabmove()
    vim.cmd.tabmove(current_tab_idx)
  end
end

M.tabmove_prev = function()
  local tablist_full = M.get_tab_list_full()
  local total_tabs = #vim.api.nvim_list_tabpages()
  local current_tab_idx = nil
  for _, v in ipairs(tablist_full) do
    if v.current == true then
      current_tab_idx = v.tabidx
      break
    end
  end
  if current_tab_idx == 1 then
    vim.cmd.tabmove()
    vim.cmd.tabmove(total_tabs - 1)
  else
    vim.cmd.tabmove()
    vim.cmd.tabmove(current_tab_idx - 2)
  end
end

return M
