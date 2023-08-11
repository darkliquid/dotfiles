-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>?", "<cmd>WhichKey<cr>", { desc = "Show keymap help" })
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle current line blame" })
vim.keymap.set("v", "<leader>gl", "<cmd>'<,'>GetCurrentBranchLink<cr>", { desc = "Get link to code on github" })
vim.keymap.set("n", "<leader>ut", "<cmd>Neotree<cr>", { desc = "Jump to tree" })
