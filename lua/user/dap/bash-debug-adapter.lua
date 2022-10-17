local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end

local utils = require("user.utils")

local bash_db_path = utils.Mason.packages .. "/bash-debug-adapter/extension/bashdb_dir"
if not utils.is_directory(bash_db_path) then
  utils.console.warn("Bash debug adapter can not found!")
  return
end

dap.adapters.sh = {
  type = "executable",
  command = "bash-debug-adapter",
}

dap.configurations.sh = {
  {
    name = "Launch Bash debugger",
    type = "sh",
    request = "launch",
    program = "${file}",
    cwd = "${fileDirname}",
    pathBashdb = bash_db_path .. "/bashdb",
    pathBashdbLib = bash_db_path,
    pathBash = "bash",
    pathCat = "cat",
    pathMkfifo = "mkfifo",
    pathPkill = "pkill",
    env = {},
    args = {},
    -- showDebugOutput = true,
    -- trace = true,
  },
  {
    name = "Launch Bash debugger with args",
    type = "sh",
    request = "launch",
    program = "${file}",
    cwd = "${fileDirname}",
    pathBashdb = bash_db_path .. "/bashdb",
    pathBashdbLib = bash_db_path,
    pathBash = "bash",
    pathCat = "cat",
    pathMkfifo = "mkfifo",
    pathPkill = "pkill",
    env = {},
    args = function()
      local args_string = vim.fn.input("Arguments: ")
      return vim.split(args_string, " +")
    end,
    -- showDebugOutput = true,
    -- trace = true,
  },
}
