local M = {
	"Selyss/mind.nvim",
	branch = "v2.2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- optional, used for icons
	},
	opts = {
		-- your configuration comes here
	},
}

function M.config()
	require("mind").setup()
end

return M
