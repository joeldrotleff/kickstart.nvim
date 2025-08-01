-- A motion plugin that uses 's' keyword to jump around
return {
  'ggandor/leap.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false,
  init = function()
    require('leap').add_default_mappings()
  end,
}
