vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.colorcolumn = { 80, 100, 120 }
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- magic WSL clipboard support
vim.g.in_wsl = os.getenv('WSL_DISTRO_NAME') ~= nil
if vim.g.in_wsl then
  vim.g.clipboard = {
    name = 'wsl clipboard',
    copy = { ["+"] = { "clip.exe" }, ["*"] = { "clip.exe" } },
    paste = { ["+"] = { "nvim_paste" }, ["*"] = { "nvim_paste" } },
    cache_enabled = true
  }
end

-- neovide settings
if vim.g.neovide then
  vim.o.guifont = "Lilex Nerd Font Mono:h11"
  vim.opt.linespace = -1
end
