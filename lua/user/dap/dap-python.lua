local status_ok, dap_python = pcall(require, "dap-python")

if not status_ok then
  return
end

-- using Mason to install debugpy DAP
local mason_install_root_dir = require("mason.settings")._DEFAULT_SETTINGS.install_root_dir
if not mason_install_root_dir then
  vim.notify(
    "Can not find mason install!, dap-python disabled -- message from: " .. vim.fn.expand("%:p"),
    vim.log.levels.WARN
  )
  return
end

local python = mason_install_root_dir .. "/packages/debugpy/venv/bin/python"
if not require("user.utils").file_exists(python) then
  vim.notify(
    "Can not find debuggy!, dap-python disabled -- message from:" .. vim.fn.expand("%:p"),
    vim.log.levels.WARN
  )
  return
end

-- local debugpy = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/debugpy"

dap_python.setup(python)
