-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {

  {
    'wellle/context.vim',
  },

  {
    'cocopon/iceberg.vim',
  },

  {
    'tpope/vim-fugitive',
    cmd = 'Git',
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
  },

  {
    'keith/swift.vim',
    event = 'VeryLazy',
  },

  -- Colorschemes - high priority / non-lazy based on
  -- recommendation from Lazy.nvim docs
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 10,
  },

  {
    'sainnhe/everforest',
    lazy = false,
    priority = 10,
  },

  {
    'rose-pine/neovim',
    lazy = false,
    priority = 10,
  },

  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 10,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {}
    end,
  },

  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup {
        default_mappings = false,
      }
    end,
  },
}
