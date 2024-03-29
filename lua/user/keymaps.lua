local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
--[[
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
]]

-- keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- Resize with arrows

keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
--[[
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
]]

-- Insert --
-- Press jk fast to enter normal mode from insert mode
-- keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Telescope --
-- keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap(
  "n",
  "<leader>f",
  "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
  opts
)
keymap("n", "<c-t>", "<cmd>Telescope live_grep<cr>", opts)
--keymap("n", "<leader>t", "<cmd>Telescope tele_tabby list<cr>", opts) -- tele_tabby, Telescope tab switcher extension
keymap(
  "n",
  "<leader>t",
  "<cmd>lua require('telescope').extensions.tele_tabby.list(require('telescope.themes').get_dropdown({ previewer = false}))<cr>",
  opts
) -- tele_tabby, Telescope tab switcher extension
keymap(
  "n",
  "<leader>s",
  "<cmd>lua require('telescope').extensions.persisted.persisted(require('telescope.themes').get_dropdown({ previewer = false}))<cr>",
  opts
) -- tele_tabby, Telescope tab switcher extension

-- Nvimtree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- LSP
keymap("n", "<leader>gd", ":lua require('user.utils').split_definition()<cr>", opts)
keymap("n", "<leader>gt", ":lua require('user.utils').tab_definition()<cr>", opts)
keymap("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>", opts)

-- null-ls fromatting
keymap("n", "<leader>a", ":Format<cr>", opts)

-- vim-mundo
keymap("n", "<leader>u", ":MundoToggle<cr>", opts)

-- DAP
keymap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", opts)
keymap("n", "<leader>ds", ":lua require'dap'.clear_breakpoints()<CR>", opts)
keymap("n", "<leader>dx", ":lua require'dap'.terminate()<CR>", opts)
keymap("n", "<leader>dc", ":lua require'dap'.continue()<CR>", opts)
keymap("n", "<leader>do", ":lua require'dap'.step_over()<CR>", opts)
keymap("n", "<leader>di", ":lua require'dap'.step_into()<CR>", opts)
keymap("n", "<leader>du", ":lua require'dapui'.toggle()<CR>", opts)

-- Harpoon
keymap("n", "<leader>ha", "<cmd>Harpoon add<cr>", opts)
keymap("n", "<leader>hs", "<cmd>Harpoon add<cr>", opts)
keymap("n", "<leader>hr", "<cmd>Harpoon remove<cr>", opts)
keymap("n", "<leader>hd", "<cmd>Harpoon remove<cr>", opts)
keymap("n", "<leader>hu", "<cmd>Harpoon ui<cr>", opts)
keymap("n", "<leader>ht", "<cmd>Telescope harpoon marks<cr>", opts)

-- Tabline
keymap("n", "H", "gT", opts)
keymap("n", "L", "gt", opts)
keymap("n", "(", "<cmd>lua require('user.tabline.utils').tabmove_prev()<cr>", opts)
keymap("n", ")", "<cmd>lua require('user.tabline.utils').tabmove_next()<cr>", opts)
