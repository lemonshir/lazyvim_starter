return {
  recommended = {
    ft = "rego",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        regal = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "rego" },
    },
  },
}
