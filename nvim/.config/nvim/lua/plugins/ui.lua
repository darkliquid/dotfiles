return {
  {
    'goolord/alpha-nvim',
    version = false,
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

    ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("r", "󰄉 " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }

      -- set highlight
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          local version = "  󰥱 v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
          local plugins = "⚡Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          local footer = version .. "\t" .. plugins .. "\n"
          dashboard.section.footer.val = footer
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  {
    'akinsho/bufferline.nvim',
    event = "FileReadPre",
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require("bufferline").setup({
        options = {
          always_show_bufferline = false,
          custom_filter = function(buf_number)
            if vim.bo[buf_number].filetype ~= "qf" then
              return true
            end
          end,
          show_close_icons = false,
          show_buffer_close_icons = false,
        }
      })
    end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = "VeryLazy",
    version = "*",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
    },
    config = true,
  },
  {
    "stevearc/dressing.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
      "adelarsq/vim-emoji-icon-theme",
      "folke/trouble.nvim",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          }
        },
        presets = {
          bottom_search = false,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
          cmdline_output_to_split = false,
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = { disabled_filetypes = { 'alpha', 'TelescopePrompt' } },
        sections = {
          lualine_x = {
            {
              require("noice").api.status.message.get_hl,
              cond = require("noice").api.status.message.has,
            },
            {
              require("noice").api.status.command.get,
              cond = require("noice").api.status.command.has,
              color = { fg = "#ff9e64" },
            },
            {
              require("noice").api.status.mode.get,
              cond = require("noice").api.status.mode.has,
              color = { fg = "#ff9e64" },
            },
            {
              require("noice").api.status.search.get,
              cond = require("noice").api.status.search.has,
              color = { fg = "#ff9e64" },
            },
          },
        },
      })
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = false,
    lazy = false,
    opts = {
      direction = "float",
      float_opts = {
        border = "curved",
        width = function()
          return math.ceil(vim.o.columns * 0.85)
        end,
        height = function()
          return math.ceil(vim.o.lines * 0.85)
        end,
      }
    },
    config = function(opts)
      -- setup a lazygit terminal
      require("toggleterm").setup(opts)
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float", float_opts = opts.float_opts })
      function _lazygit_toggle()
        lazygit:toggle()
      end

      --Need to bind here since we need the lazygit variable to be initialized
      vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>",
        { noremap = true, silent = true, desc = "Toggle LazyGit" })
    end,
  },
  {
    "willothy/flatten.nvim",
    lazy = false,
    opts = {
      window = {
        open = "current",
      },
      callbacks = {
        pre_open = function()
          -- Close toggleterm when an external open request is received
          require("toggleterm").toggle(0)
        end,
        post_open = function(bufnr, winnr, ft)
          if ft == "gitcommit" then
            -- If the file is a git commit, create one-shot autocmd to delete it on write
            -- If you just want the toggleable terminal integration, ignore this bit and only use the
            -- code in the else block
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              once = true,
              callback = function()
                -- This is a bit of a hack, but if you run bufdelete immediately
                -- the shell can occasionally freeze
                vim.defer_fn(function()
                  vim.api.nvim_buf_delete(bufnr, {})
                end, 50)
              end,
            })
          else
            -- If it's a normal file, then reopen the terminal, then switch back to the newly opened window
            -- This gives the appearance of the window opening independently of the terminal
            require("toggleterm").toggle(0)
            vim.api.nvim_set_current_win(winnr)
          end
        end,
        block_end = function()
          -- After blocking ends (for a git commit, etc), reopen the terminal
          require("toggleterm").toggle(0)
        end,
      },
    },
  },
  { 'Bekaboo/deadcolumn.nvim', event = "BufEnter" },
  {
    'RRethy/vim-illuminate',
    event = "BufEnter",
    config = function()
      vim.notify(vim.inspect(vim.g.filetypes_denylist))

      require('illuminate').configure({
        filetypes_denylist = {
          'dirvish',
          "OverseerForm",
          "OverseerList",
          "floggraph",
          "fugitive",
          "git",
          "help",
          "lazy",
          "lspinfo",
          "man",
          "neotest-output",
          "neotest-summary",
          "qf",
          "query",
          "spectre_panel",
          "startuptime",
          "toggleterm",
          "tsplayground",
          "vim",
          "TelescopePrompt",
          "alpha"
        },
      })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = "BufEnter",
    opts = {
      signs = {
        add = { text = "" },
        change = { text = "" },
        delete = { text = "" },
        topdelete = { text = "󰩹" },
        changedelete = { text = "󰩺" },
      }
    }
  }
}
