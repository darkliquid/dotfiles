-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" })

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Autoformat go files on save
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimport()
  end,
  group = format_sync_grp,
})

-- Leap
local leap_illuminate = vim.api.nvim_create_augroup("LeapIlluminate", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "LeapEnter",
  callback = function()
    require("illuminate").pause()
  end,
  group = leap_illuminate,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "LeapLeave",
  callback = function()
    require("illuminate").resume()
    vim.cmd("normal zz")
   end,
  group = leap_illuminate,
})
