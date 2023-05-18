-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

--Terminal escape
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
-- See plugins/input.lua for more keymaps
