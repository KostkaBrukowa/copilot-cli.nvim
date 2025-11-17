# copilot-cli.nvim

🤖 Seamlessly integrate GitHub Copilot CLI with Neovim for an enhanced AI-assisted coding experience!

## 🌟 Features

- [x] 🖥️ GitHub Copilot CLI terminal integration within Neovim
- [x] 💬 Interactive conversational AI agent in your terminal
- [x] 📤 Quick commands to add current buffer files (using `@` syntax)
- [x] 🩺 Send current buffer diagnostics to Copilot CLI
- [x] 🔍 Copilot CLI slash command selection UI with fuzzy search
- [x] 🔌 Fully documented [Lua API](lua/copilot_cli/api.lua) for
      programmatic interaction and custom integrations
- [x] 🔄 Auto-reload buffers on external changes (requires 'autoread')
- [x] 🛠️ Execute shell commands and manage files directly from Copilot
- [x] 🐙 GitHub integration (issues, PRs, Actions workflows)

## 🎮 Commands

- `:Copilot` - Open interactive command menu

  ```text
  Commands:
  health         🩺 Check plugin health status
  toggle         🎛️ Toggle Copilot CLI terminal window
  ask            ❓ Ask a question
  add_file       ➕ Add current file to session (using `@` syntax)
  ```

- ⚡ Direct command execution examples:

  ```vim
  :Copilot health
  :Copilot add_file
  :Copilot ask "Fix login validation"
  ```

## 🔗 Requirements

🤖 **GitHub Copilot CLI**: Install from [GitHub Docs](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line)
📋 System: **Neovim** >= 0.9.4
🌙 Lua: `folke/snacks.nvim`

## 📦 Installation

Using lazy.nvim:

```lua
{
    "KostkaBrukowa/copilot-cli.nvim",
    cmd = "Copilot",
    -- Example key mappings for common actions:
    keys = {
      { "<leader>a/", "<cmd>Copilot toggle<cr>", desc = "Toggle Copilot CLI" },
      { "<leader>aa", "<cmd>Copilot ask<cr>", desc = "Ask Copilot", mode = { "n", "v" } },
      { "<leader>af", "<cmd>Copilot add_file<cr>", desc = "Add File" },
    },
    dependencies = {
      "folke/snacks.nvim",
    },
    config = true,
  }
```

After installing, run `:Copilot health` to check if everything is set up correctly.

## ⚙️ Configuration

There is no need to call setup if you don't want to change the default options.

```lua
require("copilot_cli").setup({
  -- Command that executes Copilot CLI
  copilot_cmd = "copilot",
  -- Command line arguments passed to copilot CLI
  args = {
    -- Example: "--allow-all-tools" to auto-approve all tool usage (use with caution!)
  },
  -- Automatically reload buffers changed by Copilot CLI (requires vim.o.autoread = true)
  auto_reload = false,
  -- snacks.picker.layout.Config configuration
  picker_cfg = {
    preset = "vscode",
  },
  -- Other snacks.terminal.Opts options
  config = {
    os = { editPreset = "nvim-remote" },
    gui = { nerdFontsVersion = "3" },
  },
  win = {
    wo = { winbar = "Copilot" },
    style = "copilot_cli",
    position = "right",
  },
})
```

## 🔒 Security Considerations

GitHub Copilot CLI can execute commands and modify files on your behalf. Always review suggested commands before accepting them. Key security features:

- **Trusted Directories**: On first launch, Copilot CLI asks you to trust the directory
- **Tool Approval**: By default, you'll be prompted before Copilot executes commands or modifies files
- **Auto-approval Options**: Use `--allow-all-tools` in args for headless operation (⚠️ security risk)

For more details, see [Copilot CLI Security](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line#security-best-practices).

## 📚 API Reference

The plugin provides a structured API for programmatic integration. Access via `require("copilot_cli").api`

### Core Functions

```lua
local api = require("copilot_cli").api
```

#### `health_check()`

Verify plugin health status

```lua
api.health_check()
```

#### `toggle_terminal(opts?)`

Toggle Copilot CLI terminal window

```lua
api.toggle_terminal()
```

---

### Terminal Operations

#### `send_to_terminal(text, opts?)`

Send raw text directly to Copilot CLI

```lua
api.send_to_terminal("Fix the login validation")
```

#### `send_command(command, input?, opts?)`

Execute specific Copilot CLI slash command

```lua
api.send_command("/model")  -- Change AI model
api.send_command("/feedback")  -- Submit feedback
```

### File Management

#### `add_file(filepath)`

Add specific file to session

```lua
api.add_file("/src/utils.lua")
```

#### `add_current_file()`

Add current buffer's file (uses `add_file` internally)

```lua
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    api.add_current_file()
  end
})
```

#### `send_diagnostics_with_prompt(opts?)`

Send current buffer's diagnostics with an optional prompt

```lua
api.send_diagnostics_with_prompt()
```

---

### UI Components

#### `open_command_picker(opts?, callback?)`

Interactive slash command selector with custom handling

```lua
api.open_command_picker(nil, function(picker, item)
  if item.text == "/custom" then
    -- Implement custom command handling
  else
    -- Default behavior
    picker:close()
    api.send_command(item.text)
  end
end)
```

---

## 🎯 Use Cases

### Local Development Tasks
- Ask Copilot to make code changes in your project
- Get explanations of recent file changes
- Generate applications from scratch
- Improve code and documentation

### GitHub Integration
- List and manage your open PRs and issues
- Create pull requests from CLI
- Check PR changes for errors
- Create GitHub Actions workflows

### Shell Commands
- Get shell command suggestions
- Execute git operations with guidance
- Automate complex terminal tasks

---

## 🆚 Migrating from gemini-cli.nvim

This plugin was previously `gemini-cli.nvim`. Key changes:

- Command changed from `:Gemini` to `:Copilot`
- Configuration uses `copilot_cmd` instead of `gemini_cmd`
- Slash commands changed: `/model`, `/feedback`, `/mcp` (instead of `/compress`, `/restore`)
- Requires GitHub Copilot CLI instead of Python `gemini-cli`

---

This plugin is a Copilot CLI adaptation of [nvim-aider](https://github.com/GeorgesAlkhouri/nvim-aider).
