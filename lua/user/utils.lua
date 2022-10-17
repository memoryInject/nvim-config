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

return M
