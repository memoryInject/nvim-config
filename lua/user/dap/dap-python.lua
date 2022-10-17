local status_ok, dap_python = pcall(require, "dap-python")

if not status_ok then
  return
end

local utils = require("user.utils")

-- using Mason to install debugpy DAP
if not utils.Mason.root then
  vim.notify(
    "Can not find mason install!, dap-python disabled -- message from: " .. vim.fn.expand("%:p"),
    vim.log.levels.WARN
  )
  return
end

local python = utils.Mason.packages .. "/debugpy/venv/bin/python"
if not utils.file_exists(python) then
  vim.notify(
    "Can not find debuggy!, dap-python disabled -- message from:" .. vim.fn.expand("%:p"),
    vim.log.levels.WARN
  )
  return
end

-- local debugpy = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/debugpy"

dap_python.setup(python)

