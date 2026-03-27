if true then return {} end
return {
  {
    "xxmfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local uv = vim.uv or vim.loop

      local function root_for_buf(bufnr)
        -- Prefer a buffer-local root (more reliable than :pwd).
        local ok, root = pcall(function()
          return vim.fs.root(bufnr, { "mypy.ini", "pyproject.toml", ".git" })
        end)
        if ok and root and root ~= "" then
          return root
        end
        return uv.cwd() or vim.fn.getcwd()
      end

      local function configure_mypy(bufnr)
        local root = root_for_buf(bufnr)

        local cmd
        local venv = vim.env.VIRTUAL_ENV
        if venv and venv ~= "" then
          local candidate = venv .. "/bin/mypy"
          if uv.fs_stat(candidate) then
            cmd = candidate
          end
        end
        if not cmd then
          local candidate = root .. "/.venv/bin/mypy"
          if uv.fs_stat(candidate) then
            cmd = candidate
          end
        end
        cmd = cmd or "mypy"

        -- Use args that match nvim-lint's built-in mypy parser format.
        -- (It expects: file:lnum:col:end_lnum:end_col: severity: message [code])
        local args = {
          "--show-column-numbers",
          "--show-error-end",
          "--show-error-codes",
          "--hide-error-context",
          "--no-color-output",
          "--no-error-summary",
          "--no-pretty",
        }
        local cfg = root .. "/mypy.ini"
        if uv.fs_stat(cfg) then
          args = vim.list_extend({ "--config-file", cfg }, args)
        end

        -- Store for quick inspection/debugging.
        vim.g._mypy_lint_root = root
        vim.g._mypy_lint_cmd = cmd
        vim.g._mypy_lint_args = args

        lint.linters.mypy = vim.tbl_deep_extend("force", lint.linters.mypy or {}, {
          cmd = cmd,
          args = args,
          -- Ensure the current buffer filename is passed to mypy.
          append_fname = true,
        })
      end

      lint.linters_by_ft = lint.linters_by_ft or {}
      lint.linters_by_ft.python = { "mypy" }

      local aug = vim.api.nvim_create_augroup("diamond_mypy_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        group = aug,
        pattern = { "*.py" },
        callback = function(args)
          configure_mypy(args.buf)
          lint.try_lint("mypy")
        end,
      })

      vim.api.nvim_create_user_command("MypyLintInfo", function()
        print("root=" .. tostring(vim.g._mypy_lint_root))
        print("cmd=" .. tostring(vim.g._mypy_lint_cmd))
        print("args=" .. vim.inspect(vim.g._mypy_lint_args))
      end, {})
    end,
  },
}

