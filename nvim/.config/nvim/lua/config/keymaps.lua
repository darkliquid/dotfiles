-- Shorten function name
local keymap = vim.keymap.set

--Terminal escape
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true, desc = "Escape terminal mode"})

-- Double click to toggle folds
keymap('n', '<2-LeftMouse>', 'za', { noremap = true, silent = true })

-- See plugins/input.lua for more keymaps
