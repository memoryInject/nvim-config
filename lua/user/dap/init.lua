require "user.dap.dap-python"
require "user.dap.vscode-cpptools"
require "user.dap.nvim-dap-vscode-js"
require "user.dap.dapui"

local status_ok, _ = pcall(require, "dap")
if not status_ok then
	return
end

-- Custom breakpoint icon
vim.fn.sign_define('DapBreakpoint', {text='', texthl='ErrorMsg', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='ErrorMsg', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='WarningMsg', linehl='', numhl=''})
