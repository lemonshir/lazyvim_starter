if true then return {} end
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}

      -- Stop Treesitter from trying (and failing) to auto-download jsonc.
      opts.ignore_install = opts.ignore_install or {}
      if not vim.tbl_contains(opts.ignore_install, "jsonc") then
        table.insert(opts.ignore_install, "jsonc")
      end

      -- LazyVim may enable auto_install; force-disable to avoid noisy curl errors.
      opts.auto_install = false

      -- Also remove jsonc from ensure_installed if present.
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = vim.tbl_filter(function(lang)
          return lang ~= "jsonc"
        end, opts.ensure_installed)
      end

      return opts
    end,
  },
}
