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
      if not vim.g.neovide then
        telescope.load_extension("noice")
      end
      telescope.load_extension("notify")
      telescope.load_extension("neoclip")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "tsakirist/telescope-lazy.nvim",
      "sudormrfbin/cheatsheet.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
          keywords = {
            FIX = {
              icon = " ",
              color = "error",
              alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
            },
            TODO = { icon = " ", color = "info" },
            HACK = { icon = "󰌵️ ", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
            PERF = { icon = "󱐋 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = "󰠮 ", color = "hint", alt = { "INFO" } },
            TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
          }
        },
        config = true,
      },
      { "AckslD/nvim-neoclip.lua", config = true },
    }
  },
}
