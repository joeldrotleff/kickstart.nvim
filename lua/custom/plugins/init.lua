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

  -- Custom Themes
  { 'catppuccin/nvim' },
  { 'sainnhe/everforest' },
  { 'rose-pine/neovim' },
  { 'rebelot/kanagawa.nvim' },

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
