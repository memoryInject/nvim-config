-- HELP
-- Open session in telescope `<leader>s`, ref: keymap.lua
-- telescope options: `<cr> to load selected session`, `<C-d> delete a session`
-- CMD: `SessionLoad`, `Session<Load, Save, Delete>`

local status_ok, persisted = pcall(require, "persisted")
if not status_ok then
  return
end

local function before_save()
  local ignore_buffers = { "NvimTree", "Mundo" }
  -- loop through all the buffer and close ignore_buffers
  for _, name in ipairs(ignore_buffers) do
    vim.tbl_map(function(buf)
      if string.find(vim.api.nvim_buf_get_name(buf), name) then
        -- print(vim.api.nvim_buf_get_name(buf))
        local bnum = vim.api.nvim_buf_get_number(buf)
        vim.api.nvim_buf_delete(bnum, { force = true })
      end
    end, vim.api.nvim_list_bufs())
  end
end

persisted.setup({
  save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
  command = "VimLeavePre", -- the autocommand for which the session is saved
  silent = true, -- silent nvim message when sourcing session file
  use_git_branch = false, -- create session files based on the branch of the git enabled repository
  branch_separator = "_", -- string used to separate session directory name from branch name
  autosave = true, -- automatically save session files when exiting Neovim
  autoload = false, -- automatically load the session for the cwd on Neovim startup
  on_autoload_no_session = nil, -- function to run when `autoload = true` but there is no session to load
  allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
  ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
  before_save = before_save, -- function to run before the session is saved to disk
  after_save = nil, -- function to run after the session is saved to disk
  after_source = function()
    -- Show Gitsigns after a session loaded
    vim.cmd[[:Gitsigns reset_buffer]]
    vim.cmd[[:Gitsigns setup]]
    -- vim.cmd[[:qa!]]
  end, -- function to run after the session is sourced
  telescope = { -- options for the telescope extension
    before_source = nil, -- function to run before the session is sourced via telescope
    after_source = nil, -- function to run after the session is sourced via telescope
  },
})

require("telescope").load_extension("persisted") -- To load the telescope extension

-- TODO:autoload on setup is not working, this is a hack.
-- autoload session when nvim open like: `nvim .`
-- Create a global variable `session_exists` if session exists
-- use this variable in nvim-tree to load session at startup
local function session_exists()
  if vim.v.argv[2] == '.' then
    local current_dir = string.gsub(vim.fn.getcwd(), "-", "_")
    for _, value in ipairs(persisted.list()) do
      local filter_name = string.gsub(string.sub(value.name, 1, -6), "-", "_")
      if string.find(current_dir, filter_name) then
        vim.cmd [[:SessionLoad]]
      end
    end
  end
end

session_exists()
