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
      black = {
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
      prettier = { append_args = { "--tab-width", "4", "--indent-size", "4" } },
    },
    formatters_by_ft = {
      rego = { "opa_fmt" },
      python = { "black" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
  },
}
