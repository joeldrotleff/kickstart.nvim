return {
  'folke/zen-mode.nvim',
  event = 'VeryLazy',
  opts = {
    window = {
      backdrop = 0.75,
      width = 100,
      height = 1,
      options = {
        signcolumn = 'no',
        number = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
      },
      gitsigns = { enabled = false },
      twilight = { enabled = false },
      kitty = {
        enabled = true,
        font = '+4',
      },
    },
  },
  dependencies = { 'folke/twilight.nvim' },
}
