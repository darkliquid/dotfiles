-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_augroup("protobuf_commands", {})
vim.api.nvim_create_autocmd("Filetype", {
  group = "protobuf_commands",
  pattern = { "proto" },
  callback = function()
    vim.api.nvim_set_keymap("n", "<leader>cf", ":%!buf format<CR>", { noremap = true })
  end,
})
