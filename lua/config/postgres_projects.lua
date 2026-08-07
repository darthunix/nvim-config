local M = {}

local home = assert(vim.uv.os_homedir())

-- Add PostgreSQL source trees here. The build directory is relative to root.
M.projects = {
  {
    root = home .. "/git/postgres",
    build = "build",
  },
  {
    root = home .. "/git/postgres-review",
    build = "build",
  },
}

local function is_inside(path, root)
  return path == root or path:sub(1, #root + 1) == root .. "/"
end

local function is_postgres_tree(root)
  return vim.uv.fs_stat(vim.fs.joinpath(root, "configure.ac")) ~= nil
    and vim.uv.fs_stat(vim.fs.joinpath(root, "src", "tools", "pgindent", "pgindent")) ~= nil
end

---@param path string|nil
---@return { root: string, build: string, build_dir: string }|nil
function M.find(path)
  if not path or path == "" then
    return nil
  end

  path = vim.fs.normalize(path)
  local match

  for _, configured in ipairs(M.projects) do
    local root = vim.fs.normalize(configured.root)
    if is_inside(path, root) and is_postgres_tree(root) and (not match or #root > #match.root) then
      local build = configured.build or "build"
      match = {
        root = root,
        build = build,
        build_dir = vim.fs.joinpath(root, build),
      }
    end
  end

  return match
end

---@param bufnr integer
---@return { root: string, build: string, build_dir: string }|nil
function M.for_buffer(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  return path ~= "" and M.find(path) or nil
end

return M
