return {
  {
    -- language server setup and configuration
    "junnplus/lsp-setup.nvim",
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "ray-x/lsp_signature.nvim" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "smjonas/inc-rename.nvim" },
      {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "CursorHold", "CursorHoldI" },
        dependencies = {
          "nvim-lua/plenary.nvim",
          "jay-babu/mason-null-ls.nvim",
        },
      },
      {
        "jinzhongjia/LspUI.nvim",
        event = "VeryLazy",
      },
      { "dnlhc/glance.nvim", config = true },
    },
    config = function()
      require('lsp-setup').setup({
        default_mappings = false,
        inlay_hints = {
          enabled = true,
        },
        servers = {
          pylsp = {},
          bashls = {},
          awk_ls = {},
          bufls = {},
          clangd = {},
          cssls = {},
          dockerls = {},
          eslint = {},
          gopls = {
            settings = {
              gopls = {
                hints = {
                  rangeVariableTypes = true,
                  parameterNames = true,
                  constantValues = true,
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  functionTypeParameters = true,
                }
              }
            }
          },
          rust_analyzer = {},
          html = {},
          tsserver = {},
          lua_ls = {
            -- setup lua lsp to assume vim global is defined in config files
            on_attach = function(client, bufnr)
              -- get the filepath for the buffer the client is attached to
              local filepath = vim.api.nvim_buf_get_name(bufnr)

              -- grab the runtime paths which will include our config dirs
              local rtps = vim.api.nvim_list_runtime_paths()
              local is_cfg_file = false
              for _, rtp in ipairs(rtps) do
                -- we need to resolve symlinks to handle stowed dotfiles, etc
                if vim.startswith(filepath, vim.loop.fs_realpath(rtp)) then
                  is_cfg_file = true
                  break
                end
              end

              -- looks like the lua file is in one of our config dirs
              -- so we can assume vim global is defined
              if is_cfg_file then
                client.config.settings.Lua.diagnostics.globals = { "vim" }
                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
              end
            end,
            -- we need to define this structure otherwise we can't update it later
            settings = {
              Lua = {
                diagnostics = {
                  globals = {}
                }
              },
            }
          },
          prosemd_lsp = {},
          spectral = {},
          powershell_es = {},
          sqlls = {},
          taplo = {},
          yamlls = {
            settings = {
              yaml = {
                keyOrdering = false,
              }
            }
          },
          zls = {},
          jsonls = {},
        },
      })
      require("LspUI").setup()
    end,
  },
  {
    -- code completion
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "L3MON4D3/LuaSnip",                   dependencies = { "rafamadriz/friendly-snippets" } },
      { "ray-x/cmp-treesitter" },
      { "onsails/lspkind.nvim" },
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup({ check_ts = true })
        end,
      },
      { "hrsh7th/cmp-calc" },
      { "lukas-reineke/cmp-rg" },
    },
    config = function()
      local cmp = require("cmp")
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local neogen = require("neogen")
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      require("luasnip/loaders/from_vscode").lazy_load()

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      -- autopairs on confirm
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- general cmp config
      cmp.setup({
        formatting = {
          fields = { "menu", "abbr", "kind" },
          format = function(entry, item)

          item = lspkind.cmp_format({
            mode = "symbol_text",
            menu = ({
              buffer     = "[Buffer]",
              nvim_lsp   = "[LSP]",
              nvim_lua   = "[Lua]",
              luasnip    = "[Snippet]",
              treesitter = "[TS]",
              path       = "[Path]",
              calc       = "[Calc]",
              rg         = "[Rg]",
              copilot    = "[Copilot]",

            }),
            max_width = 50,
            symbol_map = { Copilot = "" }
          })(entry, item)
            local duplicates = {
              buffer = 1,
              path = 1,
              nvim_lsp = 0,
              luasnip = 1,
            }
            local duplicates_default = 0
            item.dup = duplicates[entry.source.name] or duplicates_default
            return item
          end
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>']      = cmp.mapping({
            i = cmp.mapping.confirm(function(fb)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fb()
              end
            end),
            s = cmp.mapping.confirm({ select = true }),
            c = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
          }),
          ['<C-Space>'] = cmp.mapping.complete(),
          -- abort autocomplete when escaping or moving out of the dropdown
          ['<Esc>']     = cmp.mapping.abort(),
          ['<Left>']    = cmp.mapping.abort(),
          ['<Right>']   = cmp.mapping.abort(),
          -- scroll docs for the completion entries
          ['<S-Up>']    = cmp.mapping.scroll_docs(-4),
          ['<S-Down>']  = cmp.mapping.scroll_docs(4),
          -- Code annotations
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif neogen.jumpable() then
              neogen.jump_next()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {
            "i",
            "s",
            "c",
          }),
          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif neogen.jumpable(true) then
              neogen.jump_prev()
            else
              fallback()
            end
          end, {
            "i",
            "s",
            "c",
          }),
        }),
        sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          }

        },
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "copilot" },
          { name = "path" },
          { name = "buffer",                 keyword_length = 5 },
          { name = "luasnip" },
          { name = "treesitter" },
          { name = "rg",                     keyword_length = 5 },
          { name = "calc" }
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered(),
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ['<Down>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
          ['<Up>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
        }),
        sources = {
          { name = "cmdline" },
          { name = "path" },
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline({
          ['<Down>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
          ['<Up>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
        }),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
  {
    -- githubs ai assistant
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        cmp = {
          enabled = true,
        },
        panel = {
          -- if true, it can interfere with completions in copilot-cmp
          enabled = false,
        },
        suggestion = {
          -- if true, it can interfere with completions in copilot-cmp
          enabled = false,
        },
      })
    end,
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
  },
  -- show the indent levels
  { "lukas-reineke/indent-blankline.nvim", event = "VeryLazy" },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("refactoring").setup(opts)
      require("telescope").load_extension("refactoring")
    end,
  }
}
