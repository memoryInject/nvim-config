local status_ok_lspconfig, _ = pcall(require, "lspconfig")
if not status_ok_lspconfig then
  return
end

local status_ok_mason, mason = pcall(require, "mason")
if not status_ok_mason then
  return
end

local status_ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_mason_lspconfig then
  return
end

require("lspconfig.ui.windows").default_options.border = "rounded"

mason.setup({
  ui = {
    border = "rounded",
  },
})
mason_lspconfig.setup()

require("user.lsp.mason-tool-installer")
require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
require("user.lsp.mason-lspconfig")
