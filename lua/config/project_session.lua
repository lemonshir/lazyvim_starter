local M = {}

local function normalize(path)
  path = vim.fs.normalize(vim.fn.resolve(vim.fn.fnamemodify(path, ":p")))
  return path == "/" and path or path:gsub("/+$", "")
end

local function file_buffers()
  return vim.tbl_filter(function(buf)
    return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
  end, vim.api.nvim_list_bufs())
end

local function inside(buf, project)
  local path = normalize(vim.api.nvim_buf_get_name(buf))
  return path == project or vim.startswith(path, project == "/" and "/" or project .. "/")
end

local function prune(project)
  for _, buf in ipairs(file_buffers()) do
    if not project or not inside(buf, project) then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end

function M.switch(project)
  project = normalize(project)
  local modified = vim.tbl_filter(function(buf)
    return vim.bo[buf].buftype == "" and vim.bo[buf].modified
  end, vim.api.nvim_list_bufs())
  if #modified > 0 then
    local names = vim.tbl_map(function(buf)
      local name = vim.api.nvim_buf_get_name(buf)
      return name ~= "" and vim.fn.fnamemodify(name, ":~:.") or "[No Name]"
    end, modified)
    vim.notify("Save or discard changes before switching projects:\n" .. table.concat(names, "\n"), vim.log.levels.WARN)
    return false
  end

  local persistence = require("persistence")
  local venv = require("config.project_venv")
  venv.clear()
  -- Repair accumulated buffers before saving the outgoing project's session.
  prune(normalize(vim.fn.getcwd()))
  if persistence.active() and #file_buffers() > 0 then
    persistence.save()
  end

  -- Sourcing a session does not remove existing buffers from other projects.
  prune()
  vim.fn.chdir(project)
  local has_session = vim.fn.filereadable(persistence.current()) == 1
    or vim.fn.filereadable(persistence.current({ branch = false })) == 1
  if has_session then
    persistence.load()
    -- Older sessions may already contain files from several projects.
    prune(project)
    if persistence.active() and #file_buffers() > 0 then
      persistence.save()
    end
  end
  vim.schedule(function()
    venv.activate(project)
    if not has_session then
      Snacks.picker.files()
    end
  end)
  return true
end

return M
