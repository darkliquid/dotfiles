-- Shorten function name
local keymap = vim.keymap.set

--Terminal escape
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true, desc = "Escape terminal mode"})
-- See plugins/input.lua for more keymaps
