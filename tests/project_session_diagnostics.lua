-- Run with: nvim --headless -u NONE -i NONE -l tests/project_session_diagnostics.lua
local repo = vim.fn.getcwd()
vim.opt.rtp:prepend(repo)
local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp .. "/old", "p")
vim.fn.mkdir(tmp .. "/new", "p")
package.loaded.persistence = {
  active = function()
    return false
  end,
  current = function()
    return tmp .. "/no-session.vim"
  end,
}
package.loaded["config.project_venv"] = {
  clear = function() end,
  activate = function() end,
}
_G.Snacks = { picker = { files = function() end } }

local diagnostics = { { lnum = 0, col = 0, message = "test", severity = vim.diagnostic.severity.ERROR } }
local ns = vim.api.nvim_create_namespace("project-session-diagnostics-test")
vim.diagnostic.config({ signs = true, underline = true, virtual_text = true, virtual_lines = true }, ns)
local ok, err = pcall(function()
  vim.fn.chdir(tmp .. "/old")
  -- LSP diagnostics can arrive for files that have not been loaded yet.
  local pending = vim.fn.bufadd(tmp .. "/old/pending.py")
  assert(not vim.api.nvim_buf_is_loaded(pending))
  vim.diagnostic.set(ns, pending, diagnostics)
  assert(require("config.project_session").switch(tmp .. "/new"))
  assert(not vim.api.nvim_buf_is_valid(pending))

  -- Reusing the server's namespace must not try to remove a stale autocmd.
  local next_buf = vim.api.nvim_create_buf(true, false)
  vim.diagnostic.set(ns, next_buf, diagnostics)
  assert(#vim.diagnostic.get(next_buf, { namespace = ns }) == 1)
  vim.diagnostic.reset(ns, next_buf)
  vim.api.nvim_buf_delete(next_buf, { force = false })
  vim.wait(20, function()
    return false
  end)
end)
vim.fn.chdir(repo)
vim.fn.delete(tmp, "rf")
assert(ok, err)
print("PASS: project switching clears pending diagnostics before buffer deletion")
