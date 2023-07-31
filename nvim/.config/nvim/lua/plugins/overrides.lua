-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        left_mouse_command = function(bufnum)
          require("edgy").goto_main()
          vim.api.nvim_win_set_buf(0, bufnum)
        end,
      },
    },
  },
  {
    "folke/flash.nvim",
    opts = {
      label = {
        rainbow = { enabled = true },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-cmdline",
      "lukas-reineke/cmp-under-comparator",
    },
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local cmp_buffer = require("cmp_buffer")
      local compare = require("cmp.config.compare")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<S-Up>"] = cmp.mapping.scroll_docs(-4),
        ["<S-Down>"] = cmp.mapping.scroll_docs(4),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      -- custom sources
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      }, {
        -- only use buffer source if the other sources aren't showing
        {
          name = "buffer",
          option = {
            -- Complete using all visible buffers
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
      })

      -- custom sorting
      opts.sorting = {
        comparators = {
          function(...)
            return cmp_buffer:compare_locality(...)
          end,
          compare.offset,
          compare.exact,
          compare.score,
          require("cmp-under-comparator").under,
          compare.recently_used,
          compare.locality,
          compare.kind,
          compare.sort_text,
          compare.length,
          compare.order,
        },
      }

      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<Down>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
          },
          ["<Up>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          },
        }),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" },
        }),
      })
    end,
  },
  -- add github_dark theme
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    config = function()
      require("github-theme").setup({
        modules = {
          cmp = true,
          diagnostic = true,
          gitsigns = true,
          indent_blankline = true,
          mini = true,
          neotree = true,
          notify = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          whichkey = true,
        },
        groups = {
          all = {
            AlphaButtons = { link = "Normal" },
            AlphaShortcut = { link = "Identifier" },
            AlphaHeader = { link = "Title" },
            AlphaFooter = { link = "NonText" },
          },
        },
      })
    end,
  },

  -- Configure LazyVim to load github_dark theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_dark",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- add telescope-fzf-native
  {
    "telescope.nvim",
    keys = {
      {
        "<leader>sl",
        function()
          require("telescope").extensions.luasnip.luasnip({})
        end,
        desc = "Snippets",
      },
    },
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "benfowler/telescope-luasnip.nvim",
      "ThePrimeagen/refactoring.nvim",
    },
    build = "make",
    config = function()
      require("telescope").load_extension("refactoring")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("luasnip")
    end,
    opts = function(_, opts)
      local telescopeConfig = require("telescope.config")
      local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
      table.insert(vimgrep_arguments, "--hidden")
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.git/*")

      opts.defaults = {
        vimgrep_arguments = vimgrep_arguments,
      }
      return opts
    end,
  },

  -- lsp additions
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    },
    init = function()
      require("lsp_lines").setup()
    end,
    keys = { { "<leader>xl", "<cmd>lua require('lsp_lines').toggle()<cr>", desc = "Toggle LSP Lines" } },
    opts = {
      diagnostics = {
        virtual_text = false,
        virtual_lines = { only_current_line = true },
      },
      inlay_hints = {
        enabled = false,
      },
      autoformat = false,
      servers = {
        bufls = {},
        cssls = {},
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons
      opts.sections.lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
          on_click=function()
            require("trouble").open()
          end
        },
      }
    end,
  },
  {
    "folke/edgy.nvim",
    opts = {
      animate = {
        enabled = false
      }
    }
  }
}
