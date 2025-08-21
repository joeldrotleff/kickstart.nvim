return {
  'echasnovski/mini.nvim',
  lazy = false,
  config = function()
    require('mini.splitjoin').setup {
      mappings = {
        toggle = '<CR>',
        split = '',
        join = '',
      },
    }
  end,
}
