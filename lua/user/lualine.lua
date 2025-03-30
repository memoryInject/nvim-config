local utils = require("user.utils")

local M = {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}

-- get filename with last dir eg: bar/foo.baz
local function get_file_name()
	local t = {}
	local full_file_path = vim.fn.expand("%")
	for str in string.gmatch(full_file_path, "([^" .. "/" .. "]+)") do
		table.insert(t, str)
	end
	local buf_modified = ""
	if utils.is_buf_modified() then
		buf_modified = "*"
	end
	if not t[#t - 1] then
		-- the file is at the root
		return t[#t] .. buf_modified
	end
	return t[#t - 1] .. "/" .. t[#t] .. buf_modified
end

function M.config()
	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				"packer",
				"NvimTree",
				"Mundo",
				"MundoDiff",
        "undotree",
				statusline = {},
				winbar = {},
			},
			ignore_focus = {
				"dap-repl",
				"dapui_scopes",
				"dapui_breakpoints",
				"dapui_stacks",
				"dapui_watches",
				"dapui_console",
			},
			always_divide_middle = true,
			globalstatus = false,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			-- lualine_c = { "filename" },
			lualine_c = { { get_file_name } },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	})
end

return M
