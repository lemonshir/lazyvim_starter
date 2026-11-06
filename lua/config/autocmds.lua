-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Sidekick computes float dimensions only when opening the window.
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("sidekick_float_resize", { clear = true }),
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.w[win].sidekick_cli then
        local config = vim.api.nvim_win_get_config(win)
        if config.relative == "editor" then
          vim.api.nvim_win_set_config(win, {
            relative = "editor",
            width = vim.o.columns,
            height = math.max(1, vim.o.lines - 1),
            row = 0,
            col = 0,
          })
        end
      end
    end
  end,
})
