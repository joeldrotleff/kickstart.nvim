return {
  'vimpostor/vim-lumen',
  lazy = false,
  priority = 10010,
  init = function()
    vim.cmd [[
				au User LumenLight echom 'rose-pine-dawn'
				au User LumenDark echom 'rose-pine-moon'
			]]
  end,
}
