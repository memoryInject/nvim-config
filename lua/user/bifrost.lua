local utils = require("user.utils")

local M = {}

M.start_ipython_and_get_pane = function()
	if M.ipython then
		utils.console.error("Ipython pane is already register in Bifrost™, to kill existing Ipython press <leader>sq")
		return
	end

	-- Save the current tmux window ID before creating the split
	local current_window = io.popen("tmux display-message -p '#{window_id}'"):read("*a")

	-- Save current list of panes before creating the new one
	local before = io.popen("tmux list-panes -F '#{pane_id}'"):read("*a")
	local before_panes = {}
	for pane in string.gmatch(before, "%%[%d]+") do
		before_panes[pane] = true
	end

	-- Create the new vertical split and run IPython
	os.execute(
		[[tmux split-window -h -c "#{pane_current_path}" "source .venv/bin/activate && ipython --no-autoindent --no-confirm-exit"]]
	)

	-- Wait a bit for the pane to be registered
	vim.wait(100, function()
		return true
	end) -- 100ms delay

	-- Get the updated list of panes
	local after = io.popen("tmux list-panes -F '#{pane_id}'"):read("*a")
	for pane in string.gmatch(after, "%%[%d]+") do
		if not before_panes[pane] then
			M.ipython = pane
		end
	end

	local pane = M.ipython
	if not pane or pane == "" then
		print("Split pane for ipython failed")
		return nil
	end

	-- Focus back to the original tmux window (Neovim window)
	-- os.execute("tmux select-window -t " .. current_window)
	os.execute("tmux last-pane")

	return pane -- fallback if something failed
end

M.send_to_ipython = function(lines)
	local pane = M.ipython
	if not pane or pane == "" then
    utils.console.error("IPython pane not found")
		return
	end

	-- https://github.com/Vigemus/iron.nvim/blob/master/lua/iron/core.lua
	local b_lines = {}
	for _, line in ipairs(lines) do
		if line:gsub("^%s*(.-)%s*$", "%1") ~= "" then
			table.insert(b_lines, line)
		end
	end

	local joined = table.concat(b_lines, "\n"):gsub('"', '\\"')
	local cmd = string.format('tmux send-keys -t %s "%s" Enter', pane, joined)
	os.execute(cmd)
end

M.send_ctrl_l_to_ipython = function()
	local pane = M.ipython
	if not pane or pane == "" then
    utils.console.error("IPython pane not found")
		return
	end

	local cmd = string.format("tmux send-keys -t %s C-l", pane)
	os.execute(cmd)
end

M.send_enter_to_ipython = function()
	local pane = M.ipython
	if not pane or pane == "" then
    utils.console.error("IPython pane not found")
		return
	end

	local cmd = string.format("tmux send-keys -t %s Enter", pane)
	os.execute(cmd)
end

M.get_selected_lines = function()
	-- HACK Break out of visual mode
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", false, true, true), "nx", false)
	local b_line, b_col
	local e_line, e_col

	local mode = vim.fn.visualmode()

	b_line, b_col = unpack(vim.fn.getpos("'<"), 2, 3)
	e_line, e_col = unpack(vim.fn.getpos("'>"), 2, 3)

	if e_line < b_line or (e_line == b_line and e_col < b_col) then
		e_line, b_line = b_line, e_line
		e_col, b_col = b_col, e_col
	end

	local lines = vim.api.nvim_buf_get_lines(0, b_line - 1, e_line, false)
	return lines
end

M.send_selection_to_ipython = function()
	local pane = M.ipython
	if not pane or pane == "" then
    utils.console.error("IPython pane not found")
		return
	end

	local lines = M.get_selected_lines()
	local _, b_col = unpack(vim.fn.getpos("'<"), 2, 3)
	local _, e_col = unpack(vim.fn.getpos("'>"), 2, 3)
	local selected = string.sub(lines[1], b_col, e_col)

	local cmd = string.format('tmux send-keys -t %s "%s" Enter', pane, selected)
	os.execute(cmd)
end

local function get_word_under_cursor()
	-- Get current line and cursor position
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	-- Use regex to extract word boundaries
	local left = line:sub(1, col):match("[_%w]+$") or ""
	local right = line:sub(col + 1):match("^[_%w]+") or ""

	return left .. right
end

M.send_word_to_ipython = function()
	local pane = M.ipython
	if not pane or pane == "" then
    utils.console.error("IPython pane not found")
		return
	end

	local word = get_word_under_cursor()
	local cmd = string.format('tmux send-keys -t %s "%s" Enter', pane, word)
	os.execute(cmd)
end

M.run_current_file_in_ipython = function()
  local pane = M.ipython
  if not pane or pane == "" then
    utils.console.error("IPython pane not found")
    return
  end

  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    utils.console.error("No file to run")
    return
  end

  local cmd = string.format('tmux send-keys -t %s "%%run %s" Enter', pane, filepath)
  os.execute(cmd)
end

M.exit_ipython = function()
	local pane = M.ipython
	if not pane or pane == "" then
    utils.console.error("IPython pane not found")
		return
	end

	local cmd = string.format("tmux send-keys -t %s exit Enter", pane)
	os.execute(cmd)
	M.ipython = nil
end

M.config = function()
	vim.keymap.set("n", "<leader>ss", function()
		M.start_ipython_and_get_pane()
	end, { desc = "Start IPython" })

	vim.keymap.set("n", "<leader>sd", function()
		M.send_ctrl_l_to_ipython()
	end, { desc = "Clear IPython" })

	vim.keymap.set("n", "<leader>s<cr>", function()
		M.send_enter_to_ipython()
	end, { desc = "Execute last line IPython" })

	vim.keymap.set("n", "<leader>sq", function()
		M.exit_ipython()
	end, { desc = "Exit IPython" })

	vim.keymap.set("v", "<leader>sc", function()
		-- -- Get the selected text range dynamically
		-- local start_line = vim.fn.line("'<")
		-- local end_line = vim.fn.line("'>")
		--
		-- -- Capture the lines between the selected range
		-- local lines = vim.fn.getline(start_line, end_line)
		local lines = M.get_selected_lines()
		-- local joined = table.concat(lines, "\n"):gsub('"', '\\"')
		-- os.execute(string.format('tmux send-keys -t %s "%s" Enter', M.ipython, joined))
		M.send_to_ipython(lines)
		-- send_multiline_to_ipython_a(M.ipython, lines)
	end, { desc = "Send selection to IPython" })

	vim.keymap.set("n", "<leader>sl", function()
		local line = vim.fn.getline(".")
		M.send_to_ipython({ line })
	end, { desc = "Send line to IPython" })

	vim.keymap.set("v", "<leader>sa", function()
		M.send_selection_to_ipython()
	end, { desc = "Send selection to IPython" })

	vim.keymap.set("n", "<leader>sw", function()
		M.send_word_to_ipython()
	end, { desc = "Send word under cursor to IPython" })

	vim.keymap.set("n", "<leader>sf", function()
		M.run_current_file_in_ipython()
	end, { desc = "Run current buffer file in IPython" })
end

M.config()

return M
