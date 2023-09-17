local status_ok, dap_vscode_js = pcall(require, "dap-vscode-js")
if not status_ok then
  return
end

dap_vscode_js.setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
})

-- NOTE: config typescript debug: https://code.visualstudio.com/docs/typescript/typescript-debugging
require("dap").configurations.typescript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Debug TypeScript with ts-node",
    runtimeExecutable = "ts-node",
    cwd = "${workspaceFolder}",
    program = "${workspaceFolder}/src/index.ts",
  },
  -- TODO: default node based configuration is jump and debug compiled js code not ts file, need fix
  --[[ {
    type = "pwa-node",
    request = "launch",
    name = "Debug TypeScript with node",
    cwd = "${workspaceFolder}",
    skipFiles = {"<node_internals>/**"},
    program = "${workspaceFolder}/src/index.ts",
    runtimeArgs = {"-r", "ts-node/register", "-r", "tsconfig-paths/register"},
    outFiles = {"${workspaceFolder}/build/**/*.js"},
    sourceMaps = true,
  }, ]]
}

require("dap").configurations.typescriptreact = {
  {
    type = "pwa-chrome",
    request = "launch",
    name = "Start Chrome with \"localhost\"",
    url = "http://localhost:5173",
    webRoot = "${workspaceFolder}/src",
    userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
  }
}

-- NOTE: config javascript debug: https://code.visualstudio.com/docs/nodejs/nodejs-debugging
-- https://github.com/mxsdev/nvim-dap-vscode-js#configurations
require("dap").configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach",
    processId = require 'dap.utils'.pick_process,
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Debug Jest Tests",
    -- trace = true, -- include debugger info
    runtimeExecutable = "node",
    runtimeArgs = {
      "./node_modules/jest/bin/jest.js",
      "--runInBand",
    },
    rootPath = "${workspaceFolder}",
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    internalConsoleOptions = "neverOpen",
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Debug Mocha Tests",
    -- trace = true, -- include debugger info
    runtimeExecutable = "node",
    runtimeArgs = {
      "./node_modules/mocha/bin/mocha.js",
    },
    rootPath = "${workspaceFolder}",
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    internalConsoleOptions = "neverOpen",
  }
}
