local M = {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- "rcarriga/nvim-notify",
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   `nvim-notify` is only needed, if you want to use the notification view.
	},
}

M.config = function()
	require("noice").setup({
		lsp = {
			progress = {
				enabled = false,
			},
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		-- routes = {
		-- 	{
		-- 		filter = {
		-- 			event = "msg_show",
		-- 			find = "%d+ [mf]ewer lines", -- Matches "1 fewer line", "3 fewer lines", etc.
		-- 		},
		-- 		opts = { skip = true },
		-- 	},
		-- 	{
		-- 		filter = {
		-- 			event = "msg_show",
		-- 			find = "%d+ more lines?", -- Matches "1 more line", "3 more lines", etc.
		-- 		},
		-- 		opts = { skip = true },
		-- 	},
		-- 	{
		-- 		filter = {
		-- 			event = "msg_show",
		-- 			find = "%d+ line less", -- Matches "1 line less.
		-- 		},
		-- 		opts = { skip = true },
		-- 	},
		-- 	{
		-- 		filter = {
		-- 			event = "msg_show",
		-- 			find = "%d+ line more", -- Matches "1 line more.
		-- 		},
		-- 		opts = { skip = true },
		-- 	},
		-- 	{
		-- 		filter = {
		-- 			event = "msg_show",
		-- 			find = "%d+ less lines?", -- Matches "1 less line", etc.
		-- 		},
		-- 		opts = { skip = true },
		-- 	},
		-- },
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = false, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
	})
end

return M
