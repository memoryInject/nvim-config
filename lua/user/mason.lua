local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
}


function M.config()

  local servers = {
     -- LSP
    "clangd",
    "cssls",
    "dockerls",
    "docker_compose_language_service",
    "elixirls",
    "emmet_ls",
    "graphql",
    "html",
    "jsonls",
    "ts_ls",
    "lua_ls",
    "markdown_oxide",
    "pyright",
    "sqlls",
    "tailwindcss",
    "bashls",
    "rust_analyzer",
    "yamlls",

    -- Linter
    -- "cpplint",
    -- "eslint",
    -- "flake8",
    -- "shellcheck",

    -- Formatter
    -- "black",
    -- "clang-format",
    -- "prettier",
    -- "stylua",
    -- "beautysh",
  }

  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  require("mason-lspconfig").setup {
    ensure_installed = servers,
  }
end

return M
