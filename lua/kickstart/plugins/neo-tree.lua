return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim',
  },
  config = function()
    vim.keymap.set('n', '\\', '<cmd>:Neotree toggle<cr>', { desc = 'Open Neotree' })
		vim.keymap.set('n', '<leader>nr', '<cmd>:Neotree reveal<cr>', { desc = '[R]eveal the current file in [N]eotree' })
  end,
  opts = {
    { follow_current_file = { enabled = true, leave_dirs_open = true } },
  },
}
