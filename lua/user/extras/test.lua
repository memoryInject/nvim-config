local width = 100
local height = 50

local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_option(buf, "filetype", "lua")

local screen_width = vim.api.nvim_get_option("columns")
local screen_height = vim.api.nvim_get_option("lines")

local row = math.floor((screen_height - height) / 2)
local col = math.floor((screen_width - width) / 2)

local win = vim.api.nvim_open_win(buf, true, {
	relative = "editor",
	row = row,
	col = col,
	width = width,
	height = height,
	style = "minimal",
	border = "rounded",
})

local file_pattern = "~/ytcutter/clip/imgs/img"
local sequence = { 1, 2, 3, 4, 5, 4, 3, 2, 1, 2, 3, 4, 5 }
local index = 1
local timer = vim.loop.new_timer()
local running = true

local function update_window()
	-- Stop animation if closed
	if not running then
		return
	end

	local filename = file_pattern .. sequence[index] .. ".txt"
	local lines = {}

	-- Read file content
	local file = io.open(vim.fn.expand(filename), "r")
	if file then
		for line in file:lines() do
			table.insert(lines, line)
		end
		file:close()
	else
		table.insert(lines, "Error loading " .. filename)
	end

	-- Update buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- Move to the next index
	index = (index % #sequence) + 1
end

-- Start infinite animation loop (runs every 100ms)
timer:start(0, 100, vim.schedule_wrap(update_window))

-- Function to close the floating window and stop the animation
_G.close_float_window = function()
	running = false
	timer:stop()
	vim.api.nvim_win_close(win, true)
end

-- Key mappings to close the window
vim.api.nvim_buf_set_keymap(buf, "n", "q", ":lua close_float_window()<CR>", { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":lua close_float_window()<CR>", { noremap = true, silent = true })
