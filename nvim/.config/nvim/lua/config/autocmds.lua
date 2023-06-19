-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("lsp-inlayhints").on_attach(client, bufnr)
  end,
})

vim.api.nvim_create_augroup("protobuf_commands", {})
vim.api.nvim_create_autocmd("Filetype", {
  group = "protobuf_commands",
  pattern = { "proto" },
  callback = function()
    vim.api.nvim_set_keymap("n", "<leader>cf", ":%!buf format<CR>", { noremap = true })
  end,
})
