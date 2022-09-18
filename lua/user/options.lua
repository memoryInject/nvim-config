-- :help options
--vim.opt.backup = false                          -- creates a backup file
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.cmdheight = 2                           -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showmode = true                         -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 2                         -- always show tabs
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
--vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 300                        -- faster completion (4000ms default)
--vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 2                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2                             -- insert 2 spaces for a tab
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = true                   -- set relative numbered lines
vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 8                           -- is one of my fav
vim.opt.sidescrolloff = 8
vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
vim.opt.cc = "80"                               -- set an 80 column border for good coding style
vim.opt.belloff = "all"

vim.opt.shortmess:append "c"


-- For WSL use win32yank.exe for clipboard
-- https://stackoverflow.com/questions/68448000/error-running-win32yank-in-neovim-invalid-value-for-argument-cmd-win32yank-exe
-- https://www.reddit.com/r/neovim/comments/g94zrl/solution_neovim_clipboard_with_wsl/
local function is_wsl()
  local version_file = io.open("/proc/version", "rb")
  if version_file ~= nil and string.find(version_file:read("*a"), "microsoft") then
    version_file:close()
    return true
  end
  return false
end

if is_wsl() then
  vim.g.clipboard = {
      name = "win32yank-wsl",
      copy = {
           ["+"] = "win32yank.exe -i --crlf",
           ["*"] = "win32yank.exe -i --crlf"
      },
      paste = {
          ["+"] = 'win32yank.exe -o --lf',
          ["*"] = 'win32yank.exe -o --lf'
      },
      cache_enabled = true
  }
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work
vim.cmd [[filetype plugin indent on]]          -- allow auto-indenting depending on file type
vim.cmd [[filetype plugin on]]
vim.cmd [[set ttyfast]]                        -- speed up scrolling
vim.cmd [[au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif]] --go to the position I was when last editing the file
