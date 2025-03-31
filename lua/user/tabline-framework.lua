local M = {
	"rafcamlet/tabline-framework.nvim",
	dependencies = { "kyazdani42/nvim-web-devicons" },
}

function M.config()
	local tabline = require("user.tabline.framework")
	tabline.setup()
end

return M
