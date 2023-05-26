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

function _G.close_to_dashboard(force)
  -- If we are on the dashboard or the buftype isn't a file, we quit
  -- TODO: Make this more robust
  local bts = {
    'prompt',
    'nofile',
    'quickfix',
  }

  for _, bt in ipairs(bts) do
    if vim.bo.buftype == bt then
      vim.cmd('quit!')
      return
    end
  end

  local fts = {
    'alpha',
    'qf',
    'cmp_menu'
  }

  for _, ft in ipairs(fts) do
    if vim.bo.filetype == ft then
      vim.cmd('quit!')
      return
    end
  end

  require('mini.bufremove').delete(0, force)

  local count = 0
  for _, buf_hndl in ipairs(vim.api.nvim_list_bufs()) do
    -- we only count listed buffers that are not nofile
    if vim.api.nvim_buf_is_loaded(buf_hndl) and vim.fn.getbufvar(buf_hndl, '&buftype') ~= 'nofile' then
      count = count + 1
    end
  end

  -- At minimum we will have 2 buffers open
  -- 1 for the scratch buffer that gets created when all others
  -- are closed and 1 for the dashboard which is always kept loaded
  if count > 2 then
    return
  end

  -- Check if the buffer has a filetype
  if vim.bo.filetype ~= '' then
    return
  end

  -- If it doesn't we check if it's empty
  if vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == '' then
    vim.cmd('Alpha')
  end
end

local keymaps = {
  -- Plugin Manager
  {
    "<leader>z",
    "<cmd>:Lazy<cr>",
    desc =
    "Plugin Manager"
  },

  -- Smart-ish Close
  {
    "<leader>q",
    function()
      close_to_dashboard(false)
    end,
    desc =
    "Close Current Buffer"
  },
  {
    "<leader>qq",
    function()
      close_to_dashboard(true)
    end,
    desc =
    "Force Close Current Buffer"
  },

  -- Legendary
  {
    itemgroup = "Legendary",
    icon = "󰨁",
    description = "Command Palette Commands",
    keymaps = {
      {
        "<leader>l",
        "<cmd>:Legendary<cr>",
        desc =
        "Command Palette"
      },
      {
        "<leader>lk",
        "<cmd>:Legendary keymaps<cr>",
        desc = "Keymaps"
      },
      {
        "<leader>lc",
        "<cmd>:Legendary commands<cr>",
        desc = "Commands"
      },
      {
        "<leader>lf",
        "<cmd>:Legendary functions<cr>",
        desc = "Functions"
      },
      {
        "<leader>la",
        "<cmd>:Legendary autocmds<cr>",
        desc = "Auto Commands"
      }
    }
  },

  -- Telescope
  {
    itemgroup = "Telescope",
    icon = "",
    description = "Finding and picking things",
    keymaps = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>",   desc = "Find Files" },
      { "<leader>ff",      "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
      { "<leader>fo",      "<cmd>Telescope oldfiles<cr>",     desc = "Recent" },
      { "<leader>fb",      "<cmd>Telescope buffers<cr>",      desc = "Buffers" },
      { "<leader>fg",      "<cmd>Telescope git_files<cr>",    desc = "Git Files" },
      { "<leader>fr",      "<cmd>Telescope live_grep<cr>",    desc = "Grep" },
      { "<leader>ft",      "<cmd>TermSelect<cr>",             desc = "Select a terminal" },
      { "<leader>fs",      "<cmd>Telescope symbols<cr>",      desc = "Pick a symbol" },
      { "<leader>fd",      "<cmd>TodoTelescope<cr>",          desc = "TODOs" },
      { "<leader>fc",      "<cmd>Telescope neoclip<cr>",      desc = "Clipboard" },
      { "<leader>fi",      "<cmd>Telescope diagnostics<cr>",  desc = "Diagnostics" },
    },
  },
  {
    itemgroup = "Coding",
    icon = "",
    description = "Code navigation and commands",
    keymaps = {
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
        function() vim.cmd(":Glance definitions") end,
        desc =
        "Go to Definition"
      },
      {
        "gr",
        function() vim.cmd(":Glance references") end,
        desc =
        "Go to References"
      },
      {
        "gD",
        function() vim.lsp.buf.declaration() end,
        desc =
        "Go to Declaration"
      },
      {
        "gt",
        function() vim.cmd(":Glance type_definitions") end,
        desc =
        "Go to Type Definition"
      },
      {
        "gi",
        function() vim.cmd(":Glance implementations") end,
        desc =
        "Go to Implementation"
      },
      { "K",          function() vim.cmd("LspUI hover") end,       desc = "Hover" },
      { "<leader>ca", function() vim.cmd("LspUI code_action") end, desc = "Code Action" },
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
        "[d",
        function() vim.cmd("LspUI diagnostic prev") end,
        desc =
        "Go to Previous Diagnostic"
      },
      {
        "]d",
        function() vim.cmd("LspUI diagnostic next") end,
        desc =
        "Go to Next Diagnostic"
      },
      { "<leader>fm", function() vim.lsp.buf.format() end, desc = "Format" },
    },
  },
  -- Misc
  {
    itemgroup = "Misc",
    icon = "",
    description = "Miscellaneous commands",
    keymaps = {
      { "<Esc>",     "<cmd>:noh<CR>",                        description = "Clear searches" },
      { "<leader>`", "<cmd>ToggleTerm<cr>",                  desc = "Toggle Terminal" },
      { "<Tab>",     { n = "<cmd>BufferLineCycleNext<cr>" }, desc = "Next tab" },
      { "<S-Tab>",   { n = "<cmd>BufferLineCyclePrev<cr>" }, desc = "Prev tab" },
      { "<leader>w", "<cmd>wincmd w<cr>",                    desc = "Cycle Splits" }
    }
  },

  -- Multiple Cursors
  -- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
  -- https://github.com/akinsho/dotfiles/blob/45c4c17084d0aa572e52cc177ac5b9d6db1585ae/.config/nvim/plugin/mappings.lua#L298

  -- 1. Position the cursor anywhere in the word you wish to change;
  -- 2. Or, visually make a selection;
  -- 3. Hit cn, type the new word, then go back to Normal mode;
  -- 4. Hit `.` n-1 times, where n is the number of replacements.
  {
    itemgroup = "Multiple Cursors",
    icon = "󰇀",
    description = "Working with multiple cursors",
    keymaps = {
      {
        "cn",
        {
          n = { "*``cgn" },
          x = { [[g:mc . "``cgn"]], opts = { expr = true } },
        },
        description = "Initiate",
      },
      {
        "cN",
        {
          n = { "*``cgN" },
          x = { [[g:mc . "``cgN"]], opts = { expr = true } },
        },
        description = "Initiate (in backwards direction)",
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
        description = "Initiate with macros",
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
        description = "Initiate with macros (in backwards direction)",
      },
    },
  },
}

if vim.g.neovide then
  table.insert(keymaps, {
    itemgroup = "Neovide",
    icon = "󰫖",
    description = "Neovide-specific commands",
    keymaps = {
      {
        "<C-ScrollWheelUp>",
        function()
          if vim.g.neovide_scale_factor < 4 then
            vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
          end
        end,
        description = "Zoom in",
      },
      {
        "<C-ScrollWheelDown>",
        function()
          if vim.g.neovide_scale_factor > 0.5 then
            vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
          end
        end,
        description = "Zoom out",
      },
    },
  })
end

return {
  { 'echasnovski/mini.bufremove', version = false, lazy = false },
  { 'echasnovski/mini.align',     version = false, lazy = false, config = true },
  {
    "ggandor/leap.nvim",
    version = false,
    event = "BufEnter",
    config = function()
      require("leap").add_default_mappings()
      vim.keymap.set({'n', 'x', 'o'}, 't', function() require'leap-ast'.leap() end, {})
    end,
    dependencies = { "tpope/vim-repeat", "ggandor/leap-ast.nvim" }
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        key_labels = {
          ["<leader>"] = "SPC"
        },
      })
    end,
  },
  {
    "mrjones2014/legendary.nvim",
    event = "VeryLazy",
    priority = 0,
    config = function()
      require("legendary").setup({
        which_key = { auto_register = true },
        select_prompt = 'Command Palette',
        keymaps = keymaps,
        icons = {
          keymap = '',
          command = '',
          fn = '',
          itemgroup = '󱡠'
        },
        sort = { item_type_bias = 'group' },
        include_legendary_cmds = false,
      })
      require("which-key").register({}, { prefix = "<leader>" })
    end,
  }
}
