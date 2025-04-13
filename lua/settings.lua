-- Disable editorconfig support (because MP uses settings I don't like)
vim.g.editorconfig = false

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`

-- Disable this for now as it's annoying for the Teams project
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Use a block cursor in normal mode
vim.opt.guicursor = ''

-- Enable true color support
vim.opt.termguicolors = true

-- Enable line break
vim.opt.linebreak = true

-- Set tab settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Prevent transparency plugin from making the statusline transparent
vim.g.exclude_groups = {
  'StatusLine',
  'StatusLineNC',
}

-- Set the colorscheme
vim.g.colorscheme = 'e-ink'

-- Set cursor to a bright/highlight color when in insert mode
vim.api.nvim_set_hl(0, 'Cursor', { bg = 'red' })

-- Make cursor a block in insert mode
vim.api.nvim_set_option_value('guicursor', 'i:block-Cursor/lCursor', { scope = 'global' })

-- Specify the path to the python interpreter because apparently it takes 1-2s to find it on startup :(
vim.g.python3_host_prog = vim.fn.expand 'which python3' 
