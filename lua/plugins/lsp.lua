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
          enabled = true,
          settings = {
            python = {
              analysis = {
                enableReachabilityAnalysis = false,
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              logLevel = "info",
            },
          },
        },
      },
    },
  },
}
