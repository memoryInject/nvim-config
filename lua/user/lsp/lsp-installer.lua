local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  local servers = {
    'jsonls',
    'sumneko_lua',
    -- 'pyright'
  }

  for _, server_name in pairs(servers) do
    if server.name == server_name then
      local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server_name)
      if has_custom_opts then
        opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
      end
    end
  end

  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)
