return {
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>c/", "<cmd>TSJToggle<cr>", desc = "Toggle split/join code block", mode = "n" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 200,
      })
    end,
  },
  {
    "mawkler/modicator.nvim",
    dependencies = "projekt0n/github-nvim-theme",
    init = function()
      vim.o.cursorline = true
      vim.o.number = true
      vim.o.termguicolors = true
    end,
    config = function()
      local style = require("github-theme.util.lualine")
      local colors = style("github_dark")
      vim.api.nvim_set_hl(0, "NormalMode", colors.normal.a)
      vim.api.nvim_set_hl(0, "InsertMode", colors.insert.a)
      vim.api.nvim_set_hl(0, "VisualMode", colors.visual.a)
      vim.api.nvim_set_hl(0, "ReplaceMode", colors.replace.a)
      vim.api.nvim_set_hl(0, "CommandMode", colors.command.a)
      vim.api.nvim_set_hl(0, "TerminalMode", colors.terminal.a)
      vim.api.nvim_set_hl(0, "TerminalNormalMode", colors.normal.b)
      vim.api.nvim_set_hl(0, "SelectMode", colors.visual.b)
      require("modicator").setup()
    end,
  },
}
