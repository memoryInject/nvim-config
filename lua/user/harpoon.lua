local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
  return
end

harpoon.setup({
  global_settings = {
    -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
    save_on_toggle = false,

    -- saves the harpoon file upon every change. disabling is unrecommended.
    save_on_change = true,

    -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
    enter_on_sendcmd = false,

    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
    tmux_autoclose_windows = false,

    -- filetypes that you want to prevent from adding to the harpoon list menu.
    excluded_filetypes = { "harpoon" },

    -- set marks specific to each git branch inside git repository
    mark_branch = true,

    -- enable tabline with harpoon marks
    tabline = false,
    tabline_prefix = "   ",
    tabline_suffix = "   ",
  },
})

vim.api.nvim_create_user_command("Harpoon", function(cmd)
  local buf_name = vim.api.nvim_buf_get_name(0)
  if cmd.args == "add" then
    require("harpoon.mark").add_file()
    vim.notify("added to harpoon: " .. buf_name)
  end

  if cmd.args == "remove" then
    require("harpoon.mark").rm_file()
    vim.notify("removed from harpoon: " .. buf_name)
  end
  if cmd.args == "ui" then
    require("harpoon.ui").toggle_quick_menu()
    vim.notify("harpoon ui")
  end
end, {
  force = true,
  nargs = "*",
  range = true,
  complete = function(arglead, line)
    -- autocompelte list
    local list = {
      "add",
      "remove",
      "ui",
    }
    local words = vim.split(line, "%s+")
    local n = #words
    local matches = {}
    if n == 2 then
      for _, func in ipairs(list) do
        if not func:match("^[a-z]") then
          -- exclude
        elseif vim.startswith(func, arglead) then
          table.insert(matches, func)
        end
      end
    end
    return matches
  end,
})
