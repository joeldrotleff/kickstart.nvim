return {
  'vimpostor/vim-lumen',
  lazy = false,
  priority = 10010,
	-- Change colorscheme when dark/light mode changes
	-- (Only necessary if current theme doesn't support both modes)
  -- init = function()
  --   vim.cmd [[
  -- 		au User LumenLight echom 'everforest-light'
  -- 		au User LumenDark echom 'rose-pine-moon'
  -- 	]]
  -- end,
}
