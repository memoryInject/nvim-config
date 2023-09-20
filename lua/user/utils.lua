local M = {}

M.get_module = function(modname)
  local ok, package = pcall(require, modname)
  if not ok then
    vim.notify(
      "Can not find module '" .. modname .. "' -- message from: " .. vim.fn.expand("%:p"),
      vim.log.levels.WARN
    )
    return nil
  end
  return package
end

M.file_exists = function(full_file_path)
  local f = io.open(full_file_path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

M.is_directory = function(path)
  return vim.fn.isdirectory(path) == 1
end

M.console = {
  log = function(msg)
    vim.notify(msg .. " -- message from: " .. vim.fn.expand("%:p"))
  end,

  warn = function(msg)
    vim.notify(msg .. " -- message from: " .. vim.fn.expand("%:p"), vim.log.levels.WARN)
  end,

  error = function(msg)
    vim.notify(msg .. " -- message from: " .. vim.fn.expand("%:p"), vim.log.levels.ERROR)
  end,

  info = function(msg)
    vim.notify(msg .. " -- message from: " .. vim.fn.expand("%:p"), vim.log.levels.INFO)
  end,
}

M.Mason = {
  bin = nil,
  packages = nil,
  root = nil,
}

local mason_settings = M.get_module("mason.settings")
if mason_settings then
  local root_path = mason_settings.current.install_root_dir
  if vim.fn.isdirectory(root_path) == 1 then
    M.Mason.root = root_path
  else
    return
  end

  local bin_path = root_path .. "/bin"
  local packages_path = root_path .. "/packages"

  if vim.fn.isdirectory(bin_path) == 1 then
    M.Mason.bin = bin_path
  end

  if vim.fn.isdirectory(packages_path) == 1 then
    M.Mason.packages = packages_path
  end
end

-- simulate user keypress
-- https://www.youtube.com/watch?v=MVW5zrQeNL0
local function feedkeys(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

M.go_to_definition = function ()
  vim.lsp.buf.definition()
  vim.defer_fn(function()
    if vim.api.nvim_buf_get_name(0) == "" then
      feedkeys("j", "n")
      feedkeys("<cr>", "n")
      feedkeys("<c-w>", "n")
      feedkeys("w", "n")
      vim.defer_fn(function ()
        vim.api.nvim_buf_delete(0, {})
        feedkeys("<c-w>", "n")
        feedkeys("w", "n")
      end, 20)
    end
  end, 20)
end

M.split_definition = function ()
  vim.cmd.vsplit()
  vim.lsp.buf.definition()
  vim.defer_fn(function()
    if vim.api.nvim_buf_get_name(0) == "" then
      feedkeys("j", "n")
      feedkeys("<cr>", "n")
      feedkeys("<c-w>", "n")
      feedkeys("w", "n")
      vim.defer_fn(function ()
        vim.api.nvim_buf_delete(0, {})
        feedkeys("<c-w>", "n")
        feedkeys("w", "n")
      end, 20)
    end
  end, 20)
end

M.tab_definition = function ()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd.tabnew("%")
  vim.api.nvim_win_set_cursor(0, pos)
  vim.lsp.buf.definition()
  -- this defer func fix the ts-server open quickfix list if more than one file found
  -- https://github.com/neovim/neovim/issues/14556
  vim.defer_fn(function()
    if vim.api.nvim_buf_get_name(0) == "" then
      feedkeys("j", "n")
      feedkeys("<cr>", "n")
      feedkeys("<c-w>", "n")
      feedkeys("w", "n")
      vim.defer_fn(function ()
        vim.api.nvim_buf_delete(0, {})
      end, 20)
    end
  end, 20)
end

return M
