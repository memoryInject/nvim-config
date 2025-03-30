local M = {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
}

function M.config()
	local harpoon = require("harpoon")

	-- REQUIRED
	harpoon:setup()
	-- REQUIRED

	vim.keymap.set("n", "<leader>ha", function()
		harpoon:list():add()
    vim.notify( vim.fn.expand("%:p") .. " added to harpoon")
	end)

	vim.keymap.set("n", "<leader>hu", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end)
end

return M
