-- neovide tweaks
if vim.g.neovide then
  vim.o.guifont = "IntoneMono Nerd Font Mono:h12"
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
