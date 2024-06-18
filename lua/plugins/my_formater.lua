local util = require("conform.util")
return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      my_flake8 = {
        command = "flake8",
        cwd = util.root_file({
          -- https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#configuration-via-a-file
          "pyproject.toml",
          "skaffold.yaml",
        }),
      },
      my_black = {
        meta = {
          url = "https://github.com/psf/black",
          description = "The uncompromising Python code formatter.",
        },
        command = "black",
        args = {
          "--line-length",
          "120",
          "--quiet",
          "-",
        },
        cwd = util.root_file({
          -- https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#configuration-via-a-file
          "pyproject.toml",
          "skaffold.yaml",
        }),
      },
    },
    formatters_by_ft = {
      python = { "my_flake8" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
  },
}
