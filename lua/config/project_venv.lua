local M = {}
local selections = {}

local function normalize(path)
  path = vim.fs.normalize(vim.fn.resolve(vim.fn.expand(path)))
  path = vim.uv.fs_realpath(path) or path
  return path == "/" and path or path:gsub("/+$", "")
end

-- Match project paths, not environment names: virtualenvwrapper records the
-- associated source directory in each environment's .project file.
function M.matches(project, venv_root)
  project = normalize(project)
  venv_root = venv_root or vim.fn.expand("~/pyvenvs")
  local exact, nested = {}, {}
  local prefix = project == "/" and "/" or project .. "/"
  for name, kind in vim.fs.dir(venv_root) do
    if kind == "directory" or kind == "link" then
      local venv = vim.fs.joinpath(venv_root, name)
      local ok, lines = pcall(vim.fn.readfile, venv .. "/.project", "", 1)
      local recorded = ok and lines[1] and vim.trim(lines[1]) or ""
      if recorded ~= "" and vim.fn.executable(venv .. "/bin/python") == 1 then
        recorded = normalize(recorded)
        if recorded == project then
          exact[#exact + 1] = venv
        elseif vim.startswith(recorded, prefix) then
          nested[#nested + 1] = venv
        end
      end
    end
  end
  local matches = #exact > 0 and exact or nested
  table.sort(matches)
  return matches
end

local function contains(parent, path)
  return path == parent or vim.startswith(path, parent == "/" and "/" or parent .. "/")
end

local function python_settings(settings, python)
  settings = settings or {}
  settings.python = settings.python or {}
  settings.python.pythonPath = python
  return settings
end

-- Servers can start after the picker has already activated the environment.
function M.before_init(_, config)
  local root = normalize(config.root_dir or vim.fn.getcwd())
  local project = normalize(vim.fn.getcwd())
  if not contains(project, root) then
    project = root
  end
  local venv = selections[project]
  if not venv then
    local venv_root = vim.fn.expand("~/pyvenvs")
    local matches = vim.fn.isdirectory(venv_root) == 1 and M.matches(project, venv_root) or {}
    if #matches == 1 then
      venv = matches[1]
    end
  end
  if venv then
    config.settings = python_settings(config.settings, venv .. "/bin/python")
  end
end

local function update_clients(project, python)
  local updated = 0
  for _, client in ipairs(vim.lsp.get_clients()) do
    if (client.name == "pyright" or client.name == "basedpyright") and not client:is_stopped() then
      local root = client.config.root_dir
      if root and contains(project, normalize(root)) then
        client.settings = python_settings(client.settings or client.config.settings, python)
        client.config.settings = client.settings
        client:notify("workspace/didChangeConfiguration", { settings = client.settings })
        updated = updated + 1
      end
    end
  end
  return updated
end

-- Replace venv-selector's default hook, which restarts every Python LSP,
-- including Ruff. Pyright accepts interpreter changes without a restart.
function M.on_venv_activate(python)
  if not python then
    return 0
  end
  return update_clients(normalize(vim.fn.getcwd()), python)
end

function M.clear()
  local selector = require("venv-selector")
  local python = selector.python()
  local bin = python and vim.fs.dirname(python)
  local inherited_bin = vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV .. "/bin"
  selector.deactivate()
  -- Some selector versions clear their interpreter state before PATH cleanup.
  vim.env.PATH = table.concat(
    vim.tbl_filter(function(entry)
      return entry ~= bin and entry ~= inherited_bin
    end, vim.split(vim.env.PATH or "", ":", { plain = true })),
    ":"
  )
end

function M.activate(project)
  project = normalize(project)
  local function current_project()
    return normalize(vim.fn.getcwd()) == project
  end
  if not current_project() then
    return
  end

  -- Session restoration may have restored another buffer's cached environment.
  M.clear()
  selections[project] = nil
  local root = vim.fn.expand("~/pyvenvs")
  local matches = vim.fn.isdirectory(root) == 1 and M.matches(project, root) or {}
  local function activate(venv)
    -- A selector can remain open while another project is selected.
    if venv and current_project() then
      selections[project] = venv
      require("venv-selector").activate_from_path(venv .. "/bin/python", "venv")
      -- Ensure reactivation works even if the selector remembers a removed PATH entry.
      local bin = venv .. "/bin"
      local paths = vim.tbl_filter(function(entry)
        return entry ~= bin
      end, vim.split(vim.env.PATH or "", ":", { plain = true }))
      table.insert(paths, 1, bin)
      vim.env.PATH = table.concat(paths, ":")
      vim.env.VIRTUAL_ENV = venv
      vim.notify("Activated " .. venv, vim.log.levels.INFO, { title = "Project venv" })
    end
  end
  if #matches == 1 then
    activate(matches[1])
  elseif #matches > 1 then
    vim.notify(
      "Multiple virtual environments found. Select manually via <leader>cv.",
      vim.log.levels.INFO,
      { title = "Project venv" }
    )
  end
end

return M
