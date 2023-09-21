vim.cmd([[
  autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc
  autocmd BufRead,BufNewFile tsconfig.json LspRestart
]])
