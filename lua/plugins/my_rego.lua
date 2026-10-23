return {
  recommended = {
    ft = "rego",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        regal = {
          root_dir = function(bufnr, on_dir)
            -- Prefer Regal's project config over the directory of an individual Rego file.
            local root = vim.fs.root(bufnr, { ".regal", ".regal.yaml" })
              or vim.fs.root(bufnr, ".git")
              or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
            on_dir(root)
          end,
        },
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
