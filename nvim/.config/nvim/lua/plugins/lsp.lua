return {
  {
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
    },
    config = function()
      require('lsp-setup').setup({
        servers = {
          pylsp = {},
          bashls = {},
          awk_ls = {},
          bufls = {},
          clangd = {},
          cssls = {},
          dockerls = {},
          eslint = {},
          gopls = {},
          html = {},
          tsserver = {},
          lua_ls = {},
          prosemd_lsp = {},
          spectral = {},
          powershell_es = {},
          sqlls = {},
          taplo = {},
          yamlls = {},
          zls = {},
          jsonls = {},
        }
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "L3MON4D3/LuaSnip" },
      { "ray-x/cmp-treesitter" },
      { "onsails/lspkind.nvim" },
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup({ check_ts = true })
        end,
      }
    },
    config = function()
      local cmp = require("cmp")
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local lspkind = require('lspkind')

      -- autopairs on confirm
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- general cmp config
      cmp.setup({
        experimental = {
          ghost_text = true,
        },
        formatting = {
          fields = { "menu", "abbr", "kind" },
          format = lspkind.cmp_format({})
        },
        mapping = {
          ['<Down>'] = { i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
          ['<Up>'] = { i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
          ['<CR>'] = { i = cmp.mapping.confirm({ select = false }) },
          ['<C-Space>'] = { i = cmp.mapping.complete() },
          ['<C-e>'] = { i = cmp.mapping.close() },
          ['<S-Up>'] = cmp.mapping.scroll_docs(-4),
          ['<S-Down>'] = cmp.mapping.scroll_docs(4),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "copilot" },
          { name = "path" },
          { name = "buffer" },
          { name = "luasnip" },
          { name = "treesitter" },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
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
    end,
  },
  {
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
}
