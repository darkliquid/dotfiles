return {
  {
    "junnplus/lsp-setup.nvim",
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "ray-x/lsp_signature.nvim" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "nvimdev/lspsaga.nvim" },
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
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require('lspkind')

      cmp.setup({
        formatting = {
          fields = { "menu", "abbr", "kind" },
          format = lspkind.cmp_format({})
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
          ['<Left>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
          ['<Right>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        }),
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
