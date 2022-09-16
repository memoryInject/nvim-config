local theme_name = "tokyonight"
local status_ok, theme = pcall(require, theme_name)
if not status_ok then
  vim.notify(theme_name .." not found!")
  return
end

theme.setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
  transparent = true, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value `:help attr-list`
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "transparent", -- style for sidebars, see below
    floats = "transparent", -- style for floating windows
    comments = "NONE", -- `:help attr-list` [ italic, NONE, bold .. ] 
    keywords = "NONE",
  },
})

vim.cmd[[colorscheme tokyonight]]

