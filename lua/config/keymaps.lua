-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set(
  "n",
  "<leader><C-a>",
  "oimport ipdb;ipdb.set_trace()<Esc>:w<Enter>j0w",
  { desc = "insert Python debugger" }
)
vim.keymap.set("n", "<leader>me", "<cmd> set mouse=a | echo 'Mouse is enabled'<cr>", { desc = "enable the mouse" })
vim.keymap.set("n", "<leader>md", "<cmd> set mouse= | echo 'Mouse is disabled'<cr>", { desc = "disable the mouse" })
vim.keymap.set("n", "<leader>gb", "<cmd> Git blame<cr>", { desc = "Git blame" })
