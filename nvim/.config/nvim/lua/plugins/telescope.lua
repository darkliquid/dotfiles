return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      telescope.setup()
      telescope.load_extension("file_browser")
      telescope.load_extension("lazy")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "tsakirist/telescope-lazy.nvim",
    }
  },
}
