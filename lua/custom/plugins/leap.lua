return {
  'ggandor/leap.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false,
  config = function()
    require('leap').add_default_mappings()
  end,
}
