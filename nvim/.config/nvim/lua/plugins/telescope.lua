return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    lazy = false,
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          file_browser = {
            hijack_netrw = false,
          },
        },
      })
      telescope.load_extension("file_browser")
      telescope.load_extension("lazy")
      telescope.load_extension("cheatsheet")
      telescope.load_extension("noice")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "tsakirist/telescope-lazy.nvim",
      "sudormrfbin/cheatsheet.nvim"
    }
  },
}
