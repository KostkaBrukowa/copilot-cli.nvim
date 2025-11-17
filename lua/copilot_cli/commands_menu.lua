local M = {}

local commands = {
  health = {
    doc = "Run copilot-cli.nvim health check",
    impl = function()
      require("copilot_cli.api").health_check()
    end,
  },
  toggle = {
    doc = "Toggle Copilot CLI terminal",
    impl = function()
      require("copilot_cli.api").toggle_terminal()
    end,
  },
  ask = {
    doc = "Ask a question",
    impl = function(input)
      require("copilot_cli.api").send_to_terminal(input)
    end,
  },
  add_file = {
    doc = "Add current file to Copilot CLI session",
    impl = function()
      require("copilot_cli.api").add_current_file()
    end,
  },
}

function M._load_command(args)
  local cmd = args[1]
  if commands[cmd] then
    table.remove(args, 1)
    commands[cmd].impl(unpack(args))
  else
    vim.notify("Invalid Copilot command: " .. (cmd or ""), vim.log.levels.INFO)
  end
end

function M._menu()
  local items = {}
  local longest_cmd = 0
  local original_buf = vim.api.nvim_get_current_buf()

  local wrapped_commands = {}
  for name, cmd in pairs(commands) do
    local new_cmd = vim.deepcopy(cmd)
    new_cmd.impl = function()
      vim.api.nvim_set_current_buf(original_buf)
      cmd.impl()
    end
    wrapped_commands[name] = new_cmd
  end

  for name, cmd in pairs(wrapped_commands) do
    table.insert(items, {
      text = name,
      description = cmd.doc,
      category = "command",
      name = name,
    })
    longest_cmd = math.max(longest_cmd, #name)
  end

  longest_cmd = longest_cmd + 2

  require("snacks.picker")({
    items = items,
    layout = require("copilot_cli.config").options.picker_cfg,
    format = function(item)
      return {
        { ("%-" .. longest_cmd .. "s"):format(item.text), "Function" },
        { " " .. item.description,                        "Comment" },
      }
    end,
    prompt = "Copilot CLI Commands > ",
    confirm = function(picker_instance, item)
      if item then
        wrapped_commands[item.name].impl()
      end
      picker_instance:close()
    end,
  })
end

M.commands = commands

return M
