return {
  'pwntester/octo.nvim',
  lazy = false,
  cmd = 'Octo',
  init = function()
    require('octo').setup()
  end,
}
