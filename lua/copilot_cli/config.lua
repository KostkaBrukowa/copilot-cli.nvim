---@class copilot_cli.Config: snacks.terminal.Opts
---@field auto_reload? boolean Automatically reload buffers changed by Copilot CLI (requires vim.o.autoread = true)
---@field copilot_cmd? string
---@field args? string[]
---@field win? snacks.win.Config
---@field picker_cfg? snacks.picker.layout.Config
local M = {}

M.defaults = {
  auto_reload = false,
  copilot_cmd = "copilot",
  args = {},
  config = {
    os = { editPreset = "nvim-remote" },
    gui = { nerdFontsVersion = "3" },
  },
  win = {
    wo = { winbar = "Copilot" },
    style = "copilot_cli",
    position = "right",
  },
  picker_cfg = {
    preset = "vscode",
  },
}

---@type copilot_cli.Config
M.options = vim.deepcopy(M.defaults)

---@param opts? copilot_cli.Config
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
  Snacks.config.style("copilot_cli", {})
  return M.options
end

return M
