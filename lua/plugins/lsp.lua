return {
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    }
  },
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
}
