local root = vim.fn.expand("~/ws/repos")
local projects = {}

for _, name in ipairs(vim.fn.readdir(root)) do
  local path = root .. "/" .. name
  if vim.fn.isdirectory(path) == 1 then
    projects[#projects + 1] = path
  end
end

return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      win = {
        position = "float",
        width = 0.999,
        height = 0.999,
      },
    },

    picker = {
      sources = {
        projects = {
          projects = projects,
        },
      },
    },
  },
}
