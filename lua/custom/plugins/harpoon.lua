local function config_harpoon()
  local harpoon = require 'harpoon'

  harpoon:setup {
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
    },
  }

  vim.keymap.set('n', '<leader>pm', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, { desc = 'Har[p]oon toggle [m]enu' })

  vim.keymap.set('n', '<leader>pp', function()
    harpoon:list():add()
  end, { desc = 'Har[pp]oon  add current buffer' })

  vim.keymap.set('n', '<leader>pq', function()
    harpoon:list():select(1)
  end, { desc = 'Har[p]oon  switch to buffer #1' })
  vim.keymap.set('n', '<leader>pw', function()
    harpoon:list():select(2)
  end, { desc = 'Har[p]oon  switch to buffer #2' })
  vim.keymap.set('n', '<leader>pe', function()
    harpoon:list():select(3)
  end, { desc = 'Har[p]oon  switch to buffer #3' })
  vim.keymap.set('n', '<leader>pr', function()
    harpoon:list():select(4)
  end, { desc = 'Har[p]oon  switch to buffer #4' })
  vim.keymap.set('n', '<leader>pt', function()
    harpoon:list():select(5)
  end, { desc = 'Har[p]oon  switch to buffer #5' })
end

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = config_harpoon,
}
