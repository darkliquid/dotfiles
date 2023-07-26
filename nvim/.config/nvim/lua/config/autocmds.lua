-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd("Filetype", {
  group = augroup("protobuf_commands"),
  pattern = { "proto" },
  callback = function()
    vim.api.nvim_set_keymap("n", "<leader>cf", ":%!buf format<CR>", { noremap = true })
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("lazy_tweaks"),
  pattern = { "lazy" },
  callback = function()
    vim.diagnostic.config({
      virtual_lines = false,
    })
  end,
})

-- update barbecue on cursor movement
vim.api.nvim_create_autocmd({
  "WinResized",
  "BufWinEnter",
  "CursorHold",
  "InsertLeave",
}, {
  group = augroup("barbecue.updater"),
  callback = function()
    require("barbecue.ui").update()
  end,
})
