local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  debug = false,
  sources = {
    formatting.prettier.with({
      extra_args = {
        "--config-precedence",
        "prefer-file",
        "--single-quote", --[[ "--jsx-single-quote" ]]
      },
    }),
    diagnostics.eslint,
    code_actions.eslint,
    formatting.black.with({ extra_args = { "--fast" } }),
    diagnostics.flake8,
    formatting.stylua,
    formatting.clang_format.with({
      extra_args = { "-style", "file" },
    }),
    diagnostics.cpplint,
    formatting.beautysh.with({ -- bash script formatter
      extra_args = { "--indent-size", "4" },
    }),
    -- diagnostics.shellcheck, -- no need to enable here it enabled by bashls LSP
  },
})

-- To disable something: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/SOURCES.md#disablequery
-- require("null_ls").disable("eslint")
-- require("null_ls").enable("eslint")
