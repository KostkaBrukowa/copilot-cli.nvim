config = require("copilot_cli.config")

describe("CopilotQuickSendCommand", function()
  local assert = require("luassert")
  local mock = require("luassert.mock")
  local spy = require("luassert.spy")
  local stub = require("luassert.stub")
  local terminal_mock
  local picker_mock

  local copilot_cli = require("copilot_cli")
  before_each(function()
    terminal_mock = mock(require("copilot_cli.terminal"), true)
    picker_mock = mock(require("copilot_cli.picker"), true)

    package.loaded["copilot_cli.commands_slash"] = {
      clear = { value = "/clear", description = "Clear the terminal screen", category = "direct" },
      chat = { value = "/chat", description = "Save, resume, or list conversation history", category = "input" },
    }

    vim.ui.input = stub.new()
  end)

  after_each(function()
    package.loaded["copilot_cli.commands_slash"] = nil
    mock.revert(terminal_mock)
    mock.revert(picker_mock)
    vim.ui.input:revert()
  end)

  it("sends a basic command to the terminal", function()
    copilot_cli.setup()

    local mock_close = spy.new(function() end)
    local mock_picker = { close = mock_close }

    picker_mock.create.invokes(function(_, confirm_callback)
      confirm_callback(mock_picker, { text = "/clear", category = "direct" })
      return mock_picker
    end)

    require("copilot_cli.api").open_command_picker()
    assert.stub(terminal_mock.command).was_called_with("/clear", nil, nil)
    assert.spy(mock_close).was_called()
  end)

  it("handles canceled input gracefully", function()
    copilot_cli.setup()

    local mock_close = spy.new(function() end)
    local mock_picker = { close = mock_close }

    picker_mock.create.invokes(function(_, confirm_callback)
      confirm_callback(mock_picker, { text = "/chat", category = "input" })
      return mock_picker
    end)

    vim.ui.input.invokes(function(_, callback)
      callback(nil) -- Simulate canceled input
    end)

    require("copilot_cli.api").open_command_picker()
    assert.stub(terminal_mock.command).was_not_called() -- Verify no command sent
    assert.spy(mock_close).was_called()
  end)

  it("sends a command with input to the terminal", function()
    copilot_cli.setup()
    local mock_close = spy.new(function() end)
    local mock_picker = { close = mock_close }

    picker_mock.create.invokes(function(_, confirm_callback)
      confirm_callback(mock_picker, { text = "/chat", category = "input" })
      return mock_picker
    end)

    vim.ui.input.invokes(function(opts, callback)
      assert.equals("Enter input for `/chat` (empty to skip):", opts.prompt) -- Verify prompt text
      callback("user_input")
    end)

    require("copilot_cli.api").open_command_picker()
    assert.stub(terminal_mock.command).was_called_with("/chat", "user_input", nil)
    assert.spy(mock_close).was_called() -- Verify picker closed
  end)
end)