local function config_harpoon()
  local harpoon = require 'harpoon'

  harpoon:setup()

  vim.keymap.set('n', '<leader>pj', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end)

  vim.keymap.set('n', '<leader>pp', function()
    harpoon:list():add()
  end)

  vim.keymap.set('n', '<leader>pa', function()
    harpoon:list():select(1)
  end)
  vim.keymap.set('n', '<leader>ps', function()
    harpoon:list():select(2)
  end)
  vim.keymap.set('n', '<leader>pd', function()
    harpoon:list():select(3)
  end)
  vim.keymap.set('n', '<leader>pf', function()
    harpoon:list():select(4)
  end)
end

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = config_harpoon,
}
