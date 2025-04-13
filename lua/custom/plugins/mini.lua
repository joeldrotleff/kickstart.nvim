return {
  'echasnovski/mini.nvim',
  lazy = false,
  llconfig = function()
    require('mini.splitjoin').setup {
      mappings = {
        toggle = '<C-m>',
        split = '',
        join = '',
      },
    }
  end,
}
