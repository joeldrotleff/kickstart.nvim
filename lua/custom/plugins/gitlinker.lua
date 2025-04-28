return {
  'ruifm/gitlinker.nvim',
  lazy = false,
  init = function()
    require('gitlinker').setup()
    print 'Gitlinker setup'
    vim.api.nvim_set_keymap(
      'n',
      '<leader>gb',
      '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
      { silent = true }
    )
  end,
}
