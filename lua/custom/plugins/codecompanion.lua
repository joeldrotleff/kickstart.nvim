return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
    'stevearc/dressing.nvim',
  },
  config = true,
  opts = {
    strategies = {
      chat = {
        adapter = 'anthropic',
      },
      inline = {
        adapter = 'anthropic',
      },
      agent = {
        adapter = 'anthropic',
      },
    },
  },
  cmd = 'CodeCompanion',
  keys = {
    { '<leader>coo', mode = 'n', '<cmd>CodeCompanionChat<cr>', noremap = true, desc = '[C]ode C[O]mpanion toggle' },
    { '<leader>coo', mode = 'v', '<cmd>CodeCompanionChat<cr>', noremap = true, desc = '[C]ode C[O]mpanion toggle' },
    { '<leader>coa', mode = 'n', '<cmd>CodeCompanionActions<cr>', noremap = true, desc = '[C]ode C[O]mpanion [A]ctions' },
    { '<leader>coa', mode = 'v', '<cmd>CodeCompanionActions<cr>', noremap = true, desc = '[C]ode C[O]mpanion [A]ctions' },
  },
  init = function()
    vim.cmd [[cab cc CodeCompanion]]
  end,
}
