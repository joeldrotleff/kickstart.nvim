-- Lua-powered greeter (shows a welcome screen on open)
return {
  'goolord/alpha-nvim',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    require('alpha').setup(require('alpha.themes.startify').config)
  end,
}
