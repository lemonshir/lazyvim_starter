return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      -- general
      "semgrep",
      "prettier",
      --bash
      "bash-language-server",
      -- bazel
      "bzl",
      -- go
      "gopls",
      -- python
      "debugpy",
      "pyright",
      "ruff-lsp",
      -- opa/rego
      "opa",
      "regal",
    },
  },
}
