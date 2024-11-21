local function set_kitty_light_mode(enabled)
  local file_path = vim.fn.expand '$HOME/.config/nvim/lua/custom/kitty.conf'

  -- Attempt to open the file for reading
  local file, err = io.open(file_path, 'r')
  if not file then
    error('Could not open file for reading: ' .. file_path .. ' - ' .. err)
  end
  local content = file:read '*all'
  file:close()

  local light_theme_name = 'LIGHTTHEMEGOESHERE'
  local dark_theme_name = 'DARKTHEMEGOESHERE'

  -- Replace the theme name based on the enabled flag
  if enabled then
    content = content:gsub(dark_theme_name, light_theme_name)
  else
    content = content:gsub(light_theme_name, dark_theme_name)
  end

  -- Attempt to open the file for writing
  file, err = io.open(file_path, 'w')
  if not file then
    error('Could not open file for writing: ' .. file_path .. ' - ' .. err)
  end
  file:write(content)
  file:close()
end

return {
  'vimpostor/vim-lumen',
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LumenLight',
      callback = function()
        -- When Neovim is set to light mode, change kitty theme to match
        set_kitty_light_mode(true)
        -- vim.fn.system('kitty @ --to unix:/tmp/kitty.sock set-colors --all --configured')
        vim.fn.system 'kill -SIGUSR1 $KITTY_PID'

        -- Highlight cursor in insert mode (needs to be set after changing theme)
        local wildmenu_hl = vim.api.nvim_get_hl_by_name('WildMenu', true).background
        vim.api.nvim_set_hl(0, 'Cursor', { bg = wildmenu_hl })
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LumenDark',
      callback = function()
        -- When Neovim is set to dark mode, change kitty theme to match
        set_kitty_light_mode(false)
        vim.fn.system 'kill -SIGUSR1 $KITTY_PID'

        -- Highlight cursor in insert mode (needs to be set after changing theme)
        local wildmenu_hl = vim.api.nvim_get_hl_by_name('WildMenu', true).background
        vim.api.nvim_set_hl(0, 'Cursor', { bg = wildmenu_hl })
      end,
    })
  end,
}
