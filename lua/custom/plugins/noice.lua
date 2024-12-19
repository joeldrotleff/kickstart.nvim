local messagesToIgnore = { 'AutoSave', 'fewer line', 'more line', 'Hunk', 'change' }


return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    routes = {
      unpack(vim.tbl_map(function(pattern)
        return {
          filter = {
            event = 'msg_show',
            find = pattern,
          },
          opts = { skip = true },
        }
      end, messagesToIgnore))
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
}
