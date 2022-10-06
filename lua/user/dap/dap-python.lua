-- pip install debugpy with virtual environment
local python = os.getenv("HOME") .. "/.local/share/nvim/dap_adapters/debugpy/bin/python"

local status_ok, dap_python = pcall(require, "dap-python")

if not status_ok then
	return
end

local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if not file_exists(python) then
  vim.notify('Can not find python virtual environment with debuggy!, dap-python disabled', vim.log.levels.WARN)
  return
end

dap_python.setup(python)
