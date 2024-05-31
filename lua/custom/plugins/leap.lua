return {

  'ggandor/leap.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  config = function()
    require('leap').add_default_mappings()
  end,
}
