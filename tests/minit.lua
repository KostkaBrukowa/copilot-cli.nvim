#!/usr/bin/env -S nvim -l

-- setting this env will override all XDG paths
vim.env.LAZY_STDPATH = ".tests"
-- this will install lazy in your stdpath
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

-- Configure plugins
-- local plugins = {
--   "nvim-lua/plenary.nvim",
-- }

-- Setup lazy.nvim
require("lazy.minit").setup({
  spec = {
    { dir = vim.uv.cwd() },
    "LazyVim/starter",
    {
      "marcinjahn/copilot-cli.nvim",
      cmd = {
        "CopilotTerminalToggle",
        "CopilotHealth",
      },
      keys = {
        { "<leader>a/", "<cmd>Copilot toggle<cr>", desc = "Open Copilot" },
        { "<leader>as", "<cmd>Copilot send<cr>", desc = "Send to Copilot", mode = { "n", "v" } },
        { "<leader>ac", "<cmd>Copilot command<cr>", desc = "Send Command To Copilot" },
        { "<leader>ab", "<cmd>Copilot buffer<cr>", desc = "Send Buffer To Copilot" },
        { "<leader>af", "<cmd>Copilot add_file<cr>", desc = "Add File to Copilot" },
      },
      dependencies = {
        "folke/snacks.nvim",
      },
      config = true,
    },
  },
})
