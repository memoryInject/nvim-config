local M = {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}

-- useful keymaps:
--  H - hide/unhide . files
--  B - hide/unhide Do not show files that have no |buflisted()| buffer.
--  C -  hide/unhide Do not show files with no git status
--  U - hide/unhide Custom list of vim regex for file/directory names that will not be shown.
--
-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
local nvim_tree_icons = {
	default = "",
	symlink = "",
	git = {
		unstaged = "",
		staged = "S",
		unmerged = "",
		renamed = "➜",
		deleted = "",
		untracked = "U",
		ignored = "◌",
	},
	folder = {
		default = "",
		open = "",
		empty = "",
		empty_open = "",
		symlink = "",
		arrow_closed = "",
		arrow_open = "",
	},
}

function M.config()
	require("nvim-tree").setup({
		actions = {
			open_file = {
				quit_on_open = true,
			},
		},
		renderer = {
			icons = {
				glyphs = nvim_tree_icons,
			},
		},
		disable_netrw = true,
		hijack_netrw = true,
		-- depricated: open_on_setup, ignore_ft_on_setup
		-- check out for persisted.lua file, the fix for open nvim-tree at start up.
		-- open_on_setup = false,
		-- ignore_ft_on_setup = {
		--   "startify",
		--   "dashboard",
		--   "alpha",
		-- },
		open_on_tab = false,
		hijack_cursor = false,
		update_cwd = true,
		hijack_directories = {
			enable = true,
			auto_open = false,
		},
		diagnostics = {
			enable = true,
			icons = {
				hint = "",
				info = "",
				warning = "",
				error = "",
			},
		},
		update_focused_file = {
			enable = true,
			update_cwd = true,
			ignore_list = {},
		},
		git = {
			enable = true,
			ignore = true,
			timeout = 500,
		},
		view = {
			width = 50,
			side = "left",
			number = false,
			relativenumber = false,
		},
	})
end

return M
