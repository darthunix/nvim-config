local postgres_projects = require("config.postgres_projects")

local function clangd_cmd(dispatchers, config)
  local cmd = { "clangd", "--background-index", "--fallback-style=none" }
  local project = postgres_projects.find(config.root_dir)

  if project then
    table.insert(cmd, "--compile-commands-dir=" .. project.build_dir)
  end

  return vim.lsp.rpc.start(cmd, dispatchers, {
    cwd = config.cmd_cwd,
    env = config.cmd_env,
    detached = config.detached,
  })
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      marksman = {
        root_dir = function(bufnr, on_dir)
          local path = vim.api.nvim_buf_get_name(bufnr)
          local file_dir = path ~= "" and vim.fs.dirname(path) or vim.uv.cwd()
          if not file_dir then
            return
          end

          local config = vim.fs.find(".marksman.toml", {
            path = file_dir,
            upward = true,
            stop = vim.env.HOME,
          })[1]
          if config then
            return on_dir(vim.fs.dirname(config))
          end

          local git = vim.fs.find(".git", {
            path = file_dir,
            upward = true,
            stop = vim.env.HOME,
          })[1]
          if git then
            return on_dir(vim.fs.dirname(git))
          end
        end,
      },
      clangd = {
        cmd = clangd_cmd,
        keys = {
          { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
          { "gr", vim.lsp.buf.references, desc = "References", has = "references", nowait = true },
          { "<C-]>", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
        },
      },
      rust_analyzer = false,
    },
  },
}
