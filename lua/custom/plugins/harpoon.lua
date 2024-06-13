local function config_harpoon()
  local harpoon = require 'harpoon'

  harpoon:setup()

  vim.keymap.set('n', '<leader>pj', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, { desc = 'Har[p]oon [j] toggle list' })

  vim.keymap.set('n', '<leader>pp', function()
    harpoon:list():add()
  end, { desc = 'Har[pp]oon  add current buffer' })

  vim.keymap.set('n', '<leader>pa', function()
    harpoon:list():select(1)
  end, { desc = 'Har[p]oon  switch to buffer #1' })
  vim.keymap.set('n', '<leader>ps', function()
    harpoon:list():select(2)
  end, { desc = 'Har[p]oon  switch to buffer #2' })
  vim.keymap.set('n', '<leader>pd', function()
    harpoon:list():select(3)
  end, { desc = 'Har[p]oon  switch to buffer #3' })
  vim.keymap.set('n', '<leader>pf', function()
    harpoon:list():select(4)
  end, { desc = 'Har[p]oon  switch to buffer #4' })
end

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = config_harpoon,
}
