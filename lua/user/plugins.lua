local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

local join_paths = function(...)
  local separator = '/'
  return table.concat({ ... }, separator)
end

-- Have packer use a popup window
packer.init({
  -- TODO: change `sanpshot = nil` to `snapshot = 'default.json'`
  -- create default config :PackerSnapshot default.json
  snapshot = nil, -- Name of the snapshot you would like to load at startup
  snapshot_path = join_paths(fn.stdpath 'config', 'snapshots'), -- Default save directory for snapshots `~/config/nvim/snapshots`
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use("wbthomason/packer.nvim") -- Have packer manage itself
  use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
  use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
  use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
  use("windwp/nvim-ts-autotag") -- Use treesitter to auto close and auto rename html tag
  use("numToStr/Comment.nvim") -- Easily comment stuff
  use("kyazdani42/nvim-web-devicons")
  use({ "kyazdani42/nvim-tree.lua" }) -- File explorer tree
  use({ "rafcamlet/tabline-framework.nvim", requires = "kyazdani42/nvim-web-devicons" })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })
  use("simnalamburt/vim-mundo") -- The undo history visualizer for VIM require pynvim
  use("NvChad/nvim-colorizer.lua") -- show color on css files 
  use("Vimjas/vim-python-pep8-indent") -- A nicer Python indentation style (treestitter is broken make sure to disable intent for python in treesitter)

  -- Colorscheme
  use("folke/tokyonight.nvim")
  use("lunarvim/darkplus.nvim")

  -- cmp plugins
  use("hrsh7th/nvim-cmp") -- The completion plugin
  use("hrsh7th/cmp-buffer") -- buffer completions
  use("hrsh7th/cmp-path") -- path completions
  use("hrsh7th/cmp-cmdline") -- cmdline completions
  use("saadparwaiz1/cmp_luasnip") -- snippet completions
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua")

  -- snippets
  use("L3MON4D3/LuaSnip") --snippet engine
  use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

  -- LSP
  use({
    "williamboman/mason.nvim", -- language server installer
    "williamboman/mason-lspconfig.nvim", -- LSP configuration
    "neovim/nvim-lspconfig", -- enable LSP
  })
  use("WhoIsSethDaniel/mason-tool-installer.nvim") -- Auto install LSP, DAP, Linter and Formatter for Mason
  -- use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters

  -- DAP
  use("mfussenegger/nvim-dap") -- enable DAP client
  use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }) -- UI for dap
  use("mfussenegger/nvim-dap-python") -- debug python (make sure pip install debugpy with virtual environment)
  use({ "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } }) -- debug javascript client
  use({
    "microsoft/vscode-js-debug",
    opt = true,
    run = "npm install --legacy-peer-deps && npm run compile",
  }) -- javascript debugger

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use({ "nvim-telescope/telescope-ui-select.nvim" })
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use("TC72/telescope-tele-tabby.nvim") -- tab switcher extension for Telescope

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("JoosepAlviste/nvim-ts-context-commentstring") -- context aware comments for jsx etc.

  -- Git
  use("lewis6991/gitsigns.nvim")

  -- Session
  use({
    "olimorris/persisted.nvim",
    --module = "persisted", -- For lazy loading
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
