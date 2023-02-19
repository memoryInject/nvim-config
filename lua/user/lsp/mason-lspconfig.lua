local opts = {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

local server_list = {
  "jsonls",
  "lua_ls",
  --"pyright"
}

require("mason-lspconfig").setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup(opts)
    for _, server in ipairs(server_list) do
      if server_name == server then
        local settings = require("user.lsp.settings." .. server_name)
        settings["on_attach"] = opts.on_attach
        settings["capabilities"] = opts.capabilities
        require("lspconfig")[server_name].setup(settings)
      end
    end
  end,
})
