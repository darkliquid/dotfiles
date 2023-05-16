local keymaps = {
  -- Plugin Manager
  { "<leader>z",       "<cmd>:Lazy<cr>",                desc = "Plugin Manager" },

  -- Smart Close
  { "<C-w>",           "<cmd>:BufDel<cr>",              desc = "Close Current Buffer" },
  { "<C-q>",           "<cmd>:BufDel!<cr>",             desc = "Force Close Current Buffer" },

  -- Legendary
  { "<leader>l",       "<cmd>:Legendary<cr>",           desc = "Command Palette" },

  -- Telescope
  { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  { "<leader>ff",      "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",   desc = "Recent" },
  { "<leader>fb",      "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
  { "<leader>fg",      "<cmd>Telescope git_files<cr>",  desc = "Git Files" },
  { "<leader>f/",      "<cmd>Telescope live_grep<cr>",  desc = "Grep" },

  -- Inc Rename
  { "<leader>rn",      "<cmd>IncRename<cr>",            desc = "Incremental Rename" },
}

return {
  {
    "ojroques/nvim-bufdel",
    event = "VeryLazy",
    config = true,
  },
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        plugins = {
          spelling = true,
        },
        key_labels = { ["<leader>"] = "SPC" },
        triggers = "auto",
      })
    end,
  },
  {
    "mrjones2014/legendary.nvim",
    event = "VeryLazy",
    config = function()
      require("legendary").setup({
        which_key = { auto_register = true },
        select_prompt = 'Command Palette',
        keymaps = keymaps,

      })
      require("which-key").register({}, { prefix = "<leader>" })
    end,
  }
}
