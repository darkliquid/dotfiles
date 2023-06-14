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
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open DiffView", mode = "n" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close DiffView", mode = "n" },
      { "<leader>gf", "<cmd>DiffviewFocusFiles<cr>", desc = "Focus DiffView", mode = "n" },
      { "<leader>gF", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle DiffView", mode = "n" },
    },
  },
  {
    "roobert/search-replace.nvim",
    keys = {
      { "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", desc = "Search & Replace in Buffer", mode = "v" },
      { "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", desc = "Search & Replace in Selection", mode = "v" },
      {
        "<C-b>",
        "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>",
        desc = "Search & Replace in Selection (cword)",
        mode = "v",
      },

      { "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", desc = "Selections" },
      { "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", desc = "Open" },
      { "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", desc = "CWord" },
      { "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", desc = "CWORD" },
      { "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", desc = "CExpr" },
      { "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", desc = "CFile" },

      { "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", desc = "Selections" },
      { "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", desc = "Open" },
      { "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", desc = "CWord" },
      { "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", desc = "CWORD" },
      { "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", desc = "CExpr" },
      { "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", desc = "CFile" },
    },
    config = function()
      require("search-replace").setup({
        -- optionally override defaults
        default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      })
      require("which-key").register({
        ["<leader>r"] = { name = "+replace" },
        ["<leader>rb"] = { name = "+multibuffer" },
      })
    end,
  },
}
