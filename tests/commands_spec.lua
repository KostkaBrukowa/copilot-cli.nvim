local _, copilot_cli = pcall(require, "copilot_cli")

describe("Command Setup", function()
  before_each(function()
    package.loaded["copilot_cli"] = nil
    copilot_cli = require("copilot_cli")
    copilot_cli.setup() -- Ensure setup is called before tests
  end)

  after_each(function()
    -- Only delete commands created by copilot_cli
    local commands_to_delete = {
      "Copilot",
      "CopilotHealth",
      "CopilotTerminalToggle",
      "CopilotTerminalSend",
      "CopilotQuickSendCommand",
      "CopilotQuickSendBuffer",
      "CopilotQuickAddFile",
      "CopilotQuickReadOnlyFile",
      "CopilotTreeAddReadOnlyFile",
      "CopilotTreeAddFile",
      "CopilotTreeDropFile",
    }
    for _, cmd_name in ipairs(commands_to_delete) do
      pcall(vim.api.nvim_del_user_command, cmd_name)
    end
  end)


  it("executes health check without error", function()
    local health_check_ok = pcall(function() copilot_cli.api.health_check() end)
    assert(health_check_ok, "health_check() should execute without error")
  end)
end)