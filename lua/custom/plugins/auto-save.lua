return {
  'Pocco81/auto-save.nvim',
  lazy = false,
  opts = {


    condition = function(buf)
      local fn = vim.fn
      local utils = require 'auto-save.utils.data'
      local ignored_filetypes = { 'harpoon' }

      if fn.getbufvar(buf, '&modifiable') == 1 and utils.not_in(fn.getbufvar(buf, '&filetype'), ignored_filetypes) then
        return true
      end
      return false
    end,
  },
}
