local messagesToIgnore = { 'AutoSave', 'fewer line', 'more line', 'Hunk', 'change' }

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    messages = {
      enabled = false,
    },
    notify = {
      enabled = false,
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
}
