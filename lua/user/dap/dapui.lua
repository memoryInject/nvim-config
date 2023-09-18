local status_dap, dap = pcall(require, "dap")
if not status_dap then
  return
end

local status_dapui, dapui = pcall(require, "dapui")
if not status_dapui then
  return
end

dapui.setup({
  icons = { expanded = "", collapsed = "", current_frame = "" },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
