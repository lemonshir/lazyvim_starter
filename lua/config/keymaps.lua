-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set(
  "n",
  "<leader><C-a>",
  "oimport ipdb;ipdb.set_trace()<Esc>:w<Enter>j0w",
  { desc = "insert Python debugger" }
)
vim.keymap.set("n", "<leader>h", "", { desc = "help" })
vim.keymap.set("n", "<leader>hl", "", { desc = "help lazy" })
vim.keymap.set("n", "<leader>hle", "<cmd>LazyExtra<cr>", { desc = "help lazy extra" })
vim.keymap.set("n", "<leader>me", "<cmd> set mouse=a | echo 'Mouse is enabled'<cr>", { desc = "enable the mouse" })
vim.keymap.set("n", "<leader>md", "<cmd> set mouse= | echo 'Mouse is disabled'<cr>", { desc = "disable the mouse" })
-- vim.keymap.set("n", "<leader>gbx", "<cmd> Git blame<cr>", { desc = "Git blame" })
-- Copy file name only (basename)
vim.keymap.set("n", "<leader>fy", function()
  local name = vim.fn.expand("%:t")
  vim.fn.setreg("+", name)
  vim.fn.setreg("*", name)
  vim.notify("Yanked file name: " .. name)
end, { desc = "Yank file name" })
-- Optional: full path instead
vim.keymap.set("n", "<leader>fY", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.fn.setreg("*", path)
  vim.notify("Yanked full file path: " .. path)
end, { desc = "Yank full file path" })
