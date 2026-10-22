return {
  "folke/sidekick.nvim",
  opts = {
    -- 1. Completely disable Next Edit Suggestions (stops copilot-language-server)
    nes = {
      enabled = false,
    },
    -- 2. Keep the local CLI terminal runner enabled
    cli = {
      enabled = true,
      mux = { enabled = false }, -- Set to true if you use Zellij or Tmux
      win = {
        layout = "float", -- Correct key for layout type
        float = {
          width = 1,
          height = vim.o.lines - 1,
          border = "none",
        },
      },
    },
  },
  keys = {
    -- nes is also useful in normal mode
    { "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    {
      "<c-.>",
      function()
        require("sidekick.cli").focus({ name = "codex" })
      end,
      desc = "Sidekick Focus Codex",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle({ name = "codex" })
      end,
      desc = "Sidekick Toggle Codex CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      -- Kept intact so you can still open the selector menu manually if needed
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close({ name = "codex" })
      end,
      desc = "Detach Codex CLI Session",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({ name = "codex", msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This to Codex",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ name = "codex", msg = "{file}" })
      end,
      desc = "Send File to Codex",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ name = "codex", msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection to Codex",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt({ name = "codex" })
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt for Codex",
    },
  },
}
