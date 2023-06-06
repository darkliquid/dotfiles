-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
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
        options = {
          styles = {
            comments = "NONE",
            keywords = "NONE",
          },
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
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
}
