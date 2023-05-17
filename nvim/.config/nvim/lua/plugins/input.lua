local keymaps = {
  -- Plugin Manager
  {
    "<leader>z",
    "<cmd>:Lazy<cr>",
    desc =
    "Plugin Manager"
  },

  -- Smart Close
  {
    "<leader>q",
    "<cmd>:BufDel<cr>",
    desc =
    "Close Current Buffer"
  },
  {
    "<leader>qq",
    "<cmd>:BufDel!<cr>",
    desc =
    "Force Close Current Buffer"
  },

  -- Legendary
  {
    "<leader>l",
    "<cmd>:Legendary<cr>",
    desc =
    "Command Palette"
  },

  -- Telescope
  { "<leader><space>", "<cmd>Telescope find_files<cr>",   desc = "Find Files" },
  { "<leader>ff",      "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
  { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",     desc = "Recent" },
  { "<leader>fb",      "<cmd>Telescope buffers<cr>",      desc = "Buffers" },
  { "<leader>fg",      "<cmd>Telescope git_files<cr>",    desc = "Git Files" },
  { "<leader>f/",      "<cmd>Telescope live_grep<cr>",    desc = "Grep" },

  -- Inc Rename
  {
    "<leader>rn",
    "<cmd>IncRename<cr>",
    desc =
    "Incremental Rename"
  },

  -- Trouble
  {
    "<leader>xx",
    "<cmd>TroubleToggle<cr>",
    desc =
    "Toggle Diagnostics"
  },

  -- LSP
  {
    "gd",
    function() require('definition-or-references').definition_or_references() end,
    desc =
    "Go to Definition/References"
  },
  {
    "gD",
    function() vim.lsp.buf.declaration() end,
    desc =
    "Go to Declaration"
  },
  {
    "gt",
    function() vim.lsp.buf.type_definition() end,
    desc =
    "Go to Type Definition"
  },
  {
    "gi",
    function() vim.lsp.buf.implementation() end,
    desc =
    "Go to Implementation"
  },
  { "K",          function() vim.lsp.buf.hover() end,       desc = "Hover" },
  { "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Code Action" },
  {
    "<leader>wa",
    function() vim.lsp.buf.add_workspace_folder() end,
    desc =
    "Add Workspace Folder"
  },
  {
    "<leader>wr",
    function() vim.lsp.buf.remove_workspace_folder() end,
    desc =
    "Remove Workspace Folder"
  },
  {
    "<leader>wl",
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    desc =
    "List Workspace Folders"
  },
  {
    "<leader>ld",
    function() vim.lsp.diagnostic.show_line_diagnostics() end,
    desc =
    "Show Line Diagnostics"
  },
  {
    "[d",
    function() vim.lsp.diagnostic.goto_prev() end,
    desc =
    "Go to Previous Diagnostic"
  },
  {
    "]d",
    function() vim.lsp.diagnostic.goto_next() end,
    desc =
    "Go to Next Diagnostic"
  },
  { "<leader>fm", function() vim.lsp.buf.formatting() end, desc = "Format" },
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
