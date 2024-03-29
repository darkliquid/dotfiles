return {
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      scope = "window",
      disabled_filetypes = { "NeoTree", "lazy", "mason", "help", "alpha", "dashboard" }
    }
  },
  {
    "willothy/flatten.nvim",
    opts = function()
      return {
        window = {
          open = function(files, argv, stdin_buf_id, guest_cwd)
            local winnr = require("utils").get_main_win()
            local focus = vim.fn.argv(#files - 1)
            -- If there's an stdin buf, focus that
            if stdin_buf_id then focus = vim.api.nvim_buf_get_name(stdin_buf_id) end
            local bufnr = vim.fn.bufnr(focus)
            if bufnr ~= nil then
              vim.api.nvim_win_set_buf(winnr, bufnr)
              vim.api.nvim_set_current_buf(bufnr)
            end
            return bufnr, winnr
          end
        },
      }
    end,
    config = true,
    lazy = false,
    priority = 1001,
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "no information available",
        },
        opts = { skip = true },
      })

      -- Only do a mini notification for autosave
      table.insert(opts.routes, {
        filter = {
          event = "msg_show",
          find = "AutoSave",
        },
        view = "mini",
      })

      opts.presets = {
        bottom_search = false,
        lsp_doc_border = true,
      }
    end,
  },
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
    dependencies = {
      "folke/which-key.nvim"
    },
    keys = function()
      return {
        {
          "<C-r>",
          "<CMD>SearchReplaceSingleBufferVisualSelection<CR>",
          desc = "Search & Replace in Buffer",
          mode = "v",
        },
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
      }
    end,
    config = function()
      require("which-key").register({
        ["<leader>r"] = { name = "+replace" },
        ["<leader>rb"] = { name = "+multibuffer" },
      })

      require("search-replace").setup({
        -- optionally override defaults
        default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      })
    end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = "BufEnter",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      create_autocmd = false,
      attach_navic = false,
    },
  },
}
