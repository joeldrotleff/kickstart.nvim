return {
  'f-person/auto-dark-mode.nvim',
  set_dark_mode = function()
    vim.cmd [[colorscheme duskfox]]
    vim.api.nvim_set_option_value('background', 'dark', {})
  end,
  set_light_mode = function()
    vim.cmd [[colorscheme edge]]
    vim.api.nvim_set_option_value('background', 'light', {})
    -- vim.cmd [[highlight Visual guibg=#a8c8f0 ctermbg=147]]
  -- vim.cmd [[highlight CursorLine guibg=#c8d8f8 ctermbg=153]]
  end,
}
