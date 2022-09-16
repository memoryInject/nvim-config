local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

--[[ -- Helper function to print table eg: print(dump(table_name))
local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end ]]

-- To see all the settings :h bufferline-configuration
bufferline.setup {
  options = {
    mode = "tabs", -- Change setup from buffer to tabs
    diagnostics = false,
    diagnostics_update_in_insert = false,
    offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
    -- :help bufferline-custom-areas
    custom_areas = {
      right = function()
        -- Get current_tab_num/total_tab_count eg: 5/10 show in the right side
        local total_tab_count = tostring(#(vim.api.nvim_list_tabpages()))
        local current_tab_num = tostring(vim.api.nvim_tabpage_get_number(0))
        local result = {
          {text = current_tab_num},
          {text = '/'},
          {text = total_tab_count},
        }
        return result
      end,
    },
  },

  -- All the settings :h bufferline-highlights
  highlights = {
    buffer_selected = {
      italic = false,
    },

  },

}
