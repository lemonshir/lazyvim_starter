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
          confirm = function(picker, item)
            picker:close()
            if not item then
              return
            end

            -- Wait for picker windows to close before saving the project layout.
            vim.schedule(function()
              local persistence = require("persistence")
              local buffers = vim.tbl_filter(function(buf)
                return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
              end, vim.api.nvim_list_bufs())
              if persistence.active() and #buffers > 0 then
                persistence.save()
              end
              require("snacks.picker.actions").load_session(picker, item)
            end)
          end,
        },
      },
    },
  },
}
