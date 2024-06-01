-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  {
    'xiyaowong/transparent.nvim',
    lazy = false,
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

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },

  -- {
  --   'vimwiki/vimwiki',
  --   event = 'VeryLazy',
  -- },
}
