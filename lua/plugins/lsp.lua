return {
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {
      search = {
        venvs = {
          command = "find " .. os.getenv("repos") .. " -maxdepth 1 -mindepth 1",
        },
      },
      options = { enable_default_searches = false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        pyright = {
          -- pyright is itself a type-checker; disable to rely on mypy instead.
          enabled = false,
          -- settings = {
          --   python = {
          --     analysis = {
          --       enableReachabilityAnalysis = false,
          --     },
          --   },
          -- },
        },
        ruff = {
          enabled = false,
        },
      },
    },
  },
}
