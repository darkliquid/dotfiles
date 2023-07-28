return {
  {
    "okuuva/auto-save.nvim",
    config = true,
    event = "BufEnter",
  },
  {
    "chrisgrieser/nvim-early-retirement",
    config = true,
    event = "VeryLazy",
  },
  {
    "ThePrimeagen/refactoring.nvim",
    config = true,
    event = "BufEnter",
    keys = {
      { "<leader>sf", function() require('telescope').extensions.refactoring.refactors() end, desc = "Refactor" },
    },
  },
  {
    "max397574/better-escape.nvim",
    config = true
  }
}
