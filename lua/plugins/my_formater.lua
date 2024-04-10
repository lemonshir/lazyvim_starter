local util = require("conform.util")
return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters = {
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
      ["python"] = { "my_black" },
      ["javascript"] = { "prettier" },
      ["javascriptreact"] = { "prettier" },
      ["typescript"] = { "prettier" },
      ["typescriptreact"] = { "prettier" },
      ["vue"] = { "prettier" },
      ["css"] = { "prettier" },
      ["scss"] = { "prettier" },
      ["less"] = { "prettier" },
      ["html"] = { "prettier" },
      ["json"] = { "prettier" },
      ["jsonc"] = { "prettier" },
      ["yaml"] = { "prettier" },
      ["markdown"] = { "prettier" },
      ["markdown.mdx"] = { "prettier" },
      ["graphql"] = { "prettier" },
      ["handlebars"] = { "prettier" },
    },
  },
}
