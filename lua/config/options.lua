-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LSP Server to use for Rust.
-- Set to "bacon-ls" to use bacon-ls instead of rust-analyzer.
-- only for diagnostics. The rest of LSP support will still be
-- provided by rust-analyzer.
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- Spelling
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "ru_ru" }

-- Language switching
vim.opt.keymap = "russian-jcukenwin"
vim.opt.iminsert = 0
vim.opt.imsearch = -1