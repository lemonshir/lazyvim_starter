return {
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        pyright = { before_init = require("config.project_venv").before_init },
        basedpyright = { before_init = require("config.project_venv").before_init },
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    cmd = "VenvSelect",
    opts = {
      hooks = { require("config.project_venv").on_venv_activate },
      search = {
        venvs = {
          command = "find "
            .. vim.fn.shellescape(vim.fn.expand("~/pyvenvs"))
            .. " -mindepth 3 -maxdepth 3 -path '*/bin/python' -print",
        },
      },
      options = { enable_default_searches = false },
    },
  },
}
