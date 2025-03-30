-- Go to the position I was when last editing the file
vim.cmd([[
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
]])

-- Highlight yank
vim.cmd([[
  augroup highlight_yank
      autocmd!
      au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Search", timeout=70})
  augroup END
]])

