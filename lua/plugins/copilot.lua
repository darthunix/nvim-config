return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Настройка Copilot через vim.g
      vim.g.copilot_no_tab_map = true -- Отключаем стандартную привязку на <Tab>
      vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = {
        ["*"] = true, -- Включить для всех типов файлов
        ["markdown"] = false, -- Отключить для Markdown
      }
    end,
  },
}
