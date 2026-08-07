local postgres_projects = require("config.postgres_projects")

local group = vim.api.nvim_create_augroup("postgres_project_style", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "c",
  callback = function(event)
    if postgres_projects.for_buffer(event.buf) then
      vim.bo[event.buf].cinoptions = "(0"
    end
  end,
})

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters = opts.formatters or {}

      local previous_c_formatters = opts.formatters_by_ft.c
      opts.formatters_by_ft.c = function(bufnr)
        if postgres_projects.for_buffer(bufnr) then
          return { "pgindent" }
        end

        if type(previous_c_formatters) == "function" then
          return previous_c_formatters(bufnr) or {}
        end
        return previous_c_formatters or {}
      end

      opts.formatters.pgindent = function(bufnr)
        local project = postgres_projects.for_buffer(bufnr)
        if not project then
          return nil
        end

        local pgindent = vim.fs.joinpath(project.root, "src", "tools", "pgindent", "pgindent")
        local indent = vim.fs.joinpath(project.build_dir, "src", "tools", "pg_bsd_indent", "pg_bsd_indent")

        return {
          inherit = false,
          command = pgindent,
          args = { "--indent=" .. indent, "$FILENAME" },
          stdin = false,
          cwd = function()
            return project.root
          end,
          condition = function()
            return vim.fn.executable(pgindent) == 1 and vim.fn.executable(indent) == 1
          end,
        }
      end
    end,
  },
}
