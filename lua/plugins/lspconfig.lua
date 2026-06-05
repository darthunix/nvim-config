return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        cmd = { "clangd", "--fallback-style=none" },
        on_attach = function(client, bufnr) end,
      },
      rust_analyzer = false,
    },
  },
}
