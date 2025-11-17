-- Type definitions
---@alias CommandCategory "input"|"direct"

---@class Command
---@field value string The command string with prefix
---@field description string Description of the command's function
---@field category CommandCategory The category this command belongs to

-- Constants
---@type string
local COMMAND_PREFIX = "/"

-- Command registry
---@type table<string, Command>
local commands = {
  model = {
    value = COMMAND_PREFIX .. "model",
    description = "Change the AI model used by Copilot CLI",
    category = "direct",
  },
  feedback = {
    value = COMMAND_PREFIX .. "feedback",
    description = "Submit feedback about Copilot CLI (survey/bug report/feature request)",
    category = "direct",
  },
  mcp = {
    value = COMMAND_PREFIX .. "mcp",
    description = "List and manage Model Context Protocol (MCP) servers",
    category = "direct",
  },
}

return commands
