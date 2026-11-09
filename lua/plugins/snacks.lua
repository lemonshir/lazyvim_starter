local root = vim.fn.expand("~/ws/repos")
local projects = { vim.fn.expand("$HOME"), "/tmp" }

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
        width = 0, -- Snacks uses 0 for the full available width.
        height = function()
          return vim.o.lines - 1
        end,
      },
    },

    picker = {
      sources = {
        notifications = {
          win = {
            preview = {
              wo = {
                wrap = true,
                linebreak = true,
              },
            },
          },
        },
        projects = {
          projects = projects,
          confirm = function(picker, item)
            picker:close()
            if not item then
              return
            end

            -- Wait for picker windows to close before saving the project layout.
            vim.schedule(function()
              require("config.project_session").switch(item.file)
            end)
          end,
        },
      },
    },
  },
}
