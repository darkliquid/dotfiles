-- Functions for multiple cursors
vim.g.mc = vim.api.nvim_replace_termcodes([[y/\V<C-r>=escape(@", '/')<CR><CR>]], true, true, true)

function SetupMultipleCursors()
  vim.keymap.set(
    "n",
    "<Enter>",
    [[:nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]],
    { remap = true, silent = true }
  )
end

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
  {
    itemgroup = "Telescope",
    icon = "🔭",
    description = "Finding and picking things",
    keymaps = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>",   desc = "Find Files" },
      { "<leader>ff",      "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
      { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",     desc = "Recent" },
      { "<leader>fb",      "<cmd>Telescope buffers<cr>",      desc = "Buffers" },
      { "<leader>fg",      "<cmd>Telescope git_files<cr>",    desc = "Git Files" },
      { "<leader>f/",      "<cmd>Telescope live_grep<cr>",    desc = "Grep" },
      { "<leader>fn",      "<cmd>Telescope notify<cr>",       desc = "Notifications" }
    },
  },
  {
    itemgroup = "Coding",
    icon = "🛠️",
    description = "Code navigation and commands",
    keymaps = {
      -- Trouble
      {
        "<leader>xx",
        "<cmd>TroubleToggle<cr>",
        desc =
        "Toggle Diagnostics"
      },
      -- Inc Rename
      {
        "<leader>rn",
        "<cmd>IncRename<cr>",
        desc =
        "Incremental Rename"
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
      { "<leader>fm", function() vim.lsp.buf.format() end, desc = "Format" },
    },
  },
  -- Misc
  { "<Esc>", "<cmd>:noh<CR>", description = "Clear searches" },

  -- Multiple Cursors
  -- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
  -- https://github.com/akinsho/dotfiles/blob/45c4c17084d0aa572e52cc177ac5b9d6db1585ae/.config/nvim/plugin/mappings.lua#L298

  -- 1. Position the cursor anywhere in the word you wish to change;
  -- 2. Or, visually make a selection;
  -- 3. Hit cn, type the new word, then go back to Normal mode;
  -- 4. Hit `.` n-1 times, where n is the number of replacements.
  {
    itemgroup = "Multiple Cursors",
    icon = "🔁",
    description = "Working with multiple cursors",
    keymaps = {
      {
        "cn",
        {
          n = { "*``cgn" },
          x = { [[g:mc . "``cgn"]], opts = { expr = true } },
        },
        description = "Inititiate",
      },
      {
        "cN",
        {
          n = { "*``cgN" },
          x = { [[g:mc . "``cgN"]], opts = { expr = true } },
        },
        description = "Inititiate (in backwards direction)",
      },

      -- 1. Position the cursor over a word; alternatively, make a selection.
      -- 2. Hit cq to start recording the macro.
      -- 3. Once you are done with the macro, go back to normal mode.
      -- 4. Hit Enter to repeat the macro over search matches.
      {
        "cq",
        {
          n = { [[:\<C-u>call v:lua.SetupMultipleCursors()<CR>*``qz]] },
          x = { [[":\<C-u>call v:lua.SetupMultipleCursors()<CR>gv" . g:mc . "``qz"]], opts = { expr = true } },
        },
        description = "Inititiate with macros",
      },
      {
        "cQ",
        {
          n = { [[:\<C-u>call v:lua.SetupMultipleCursors()<CR>#``qz]] },
          x = {
            [[":\<C-u>call v:lua.SetupMultipleCursors()<CR>gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]],
            opts = { expr = true },
          },
        },
        description = "Inititiate with macros (in backwards direction)",
      },
    },
  },
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
        icons = {
          keymap = '⌨️',
          command = '💬',
          fn = '⚙️',
          itemgroup = '👪'
        },
        sort = { item_type_bias = 'group' },
      })
      require("which-key").register({}, { prefix = "<leader>" })
    end,
  }
}
