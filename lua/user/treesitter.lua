local M = {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
}

function M.config()
	require("nvim-treesitter.configs").setup({
		modules = {},
		auto_install = false,
		ignore_install = { "all" },
		sync_install = false,
		ensure_installed = {
			"lua",
			"markdown",
			"markdown_inline",
			"bash",
			"python",
			"c",
			"rust",
			"cpp",
			"dockerfile",
			"dot",
			"elixir",
			"heex",
			"html",
			"htmldjango",
			"javascript",
			"typescript",
			"vim",
			"vimdoc",
			"cmake",
			"css",
			"csv",
			"go",
			"jsdoc",
			"json",
			"json5",
			"jsonc",
			"make",
			"scss",
			"sql",
			"tmux",
			"tsx",
			"typespec",
			"typoscript",
			"yaml",
		},
		autopairs = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		highlight = {
			enable = true, -- false will disable the whole extension
			disable = { "" }, -- list of language that will be disabled
			additional_vim_regex_highlighting = true,
		},
		indent = { enable = true, disable = { "yaml", "python" } },
	})
end

return M
