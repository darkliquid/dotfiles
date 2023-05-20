vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.colorcolumn = { 80, 100, 120 }
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- the number of spaces inserted for each indentation
local in_wsl = os.getenv('WSL_DISTRO_NAME') ~= nil
if in_wsl then
  vim.g.clipboard = {
    name = 'wsl clipboard',
    copy = { ["+"] = { "clip.exe" }, ["*"] = { "clip.exe" } },
    paste = { ["+"] = { "nvim_paste" }, ["*"] = { "nvim_paste" } },
    cache_enabled = true
  }
end
