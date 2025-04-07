--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

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

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- New virtual lines feature from Neovim 0.11
vim.diagnostic.config {
  virtual_lines = { current_line = true, enabled = true },
  virtual_text = true,
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
local show_all_virtualtext = function()
  vim.diagnostic.config {
    virtual_text = {
      severity = vim.diagnostic.severity,
    },
  }
end
local show_error_virtualtext = function()
  vim.diagnostic.config {
    virtual_text = {
      severity = vim.diagnostic.severity.ERROR,
    },
  }
end
local hide_virtualtext = function()
  vim.diagnostic.config { virtual_text = false }
end
local goto_next_diagnostic = function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
end
local goto_prev_diagnostic = function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
end

-- Keymaps for toggling what shows for virtual text
vim.keymap.set('n', '<leader>vs', show_all_virtualtext, { desc = '[V]irtualtext [S]how' })
vim.keymap.set('n', '<leader>ve', show_error_virtualtext, { desc = '[V]irtualtext [E]rrors only' })
vim.keymap.set('n', '<leader>vh', hide_virtualtext, { desc = '[V]irtualtext [H]ide' })

vim.keymap.set('n', ']e', goto_next_diagnostic, { desc = 'Jump to next [E]iagnostic' })
vim.keymap.set('n', '[e', goto_prev_diagnostic, { desc = 'Jump to previous [E]iagnostic' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({

  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      }
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`

      local telescope_ignore_patterns = {
        -- This is an attempt to exclude source code files from cluttering up
        -- Telescope's "recent files" list.
        '/private/',
        '.local',
        'project.pbxproj',
        'no_backend',
      }
      local telescope_ignore_toggle = true

      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          file_ignore_patterns = telescope_ignore_patterns,
          layout_config = {
            vertical = {
              width = 0.999,
              height = 0.999,
            },
            horizontal = {
              width = 0.999,
              height = 0.999,
            },
          },
        },
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', function()
        local tel = require 'telescope'
        telescope_ignore_toggle = not telescope_ignore_toggle
        if telescope_ignore_toggle then
          tel.setup { defaults = { file_ignore_patterns = telescope_ignore_patterns } }
          print 'Telescope ignore source code files: ON'
        else
          tel.setup { defaults = { file_ignore_patterns = {} } }
          print 'Telescope ignore source code files: OFF'
        end
      end, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sc', builtin.git_status, { desc = '[S]earch [C]hanged files' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>st', builtin.colorscheme, { desc = '[S]earch neovim Colorscheme aka [T]heme' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files by name
      vim.keymap.set('n', '<leader>sv', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch Neo[v]im files by name' })

      -- Shortcut for searching *within* your Neovim configuration files
      vim.keymap.set('n', '<leader>sV', function()
        builtin.grep_string { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch within Neo[V]im files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files {
          cwd = '~/Documents/daily_notes',

          -- Sort by most recently modified, since that's usually what I want when looking for notes
          find_command = { 'rg', '--no-config', '--files', '--sortr=created' },
        }
      end, { desc = '[S]earch [n]otes by name in daily_notes folder' })

      vim.keymap.set('n', '<leader>sN', function()
        builtin.grep_string {
          cwd = '~/Documents/daily_notes',
        }
      end, { desc = '[S]earch within [N]otes in daily_notes folder' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local builtin = require 'telescope.builtin'

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')

          map('gD', function()
            builtin.lsp_definitions { jump_type = 'vsplit' }
          end, '[G]oto [Definition] in new split')

          -- Find references for the word under your cursor.
          map('gr', builtin.lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      local lspconfig = require 'lspconfig'

      -- This one still isn't brew installable, seems too fresh
      -- ...maybe someday
      -- lspconfig.fish_lsp.setup {}

      lspconfig.pyright.setup {}
      lspconfig.jsonls.setup {}
      lspconfig.tailwindcss.setup {}
      lspconfig.lua_ls.setup {
        opts = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- Deno and Typescript LSPs can conflict, so use a root_dir to differentiate
      lspconfig.denols.setup {
        root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
        cmd = { 'deno', 'lsp' },
      }

      lspconfig.ts_ls.setup {
        root_dir = lspconfig.util.root_pattern 'tsconfig.json',
        single_file_support = false,
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      -- format_on_save = {
      --   -- These options will be passed to conform.format()
      --   timeout_ms = 500,
      --   lsp_format = 'fallback',
      -- },
      notify_on_error = true,
      formatters_by_ft = {
        lua = { 'stylua' },

        swift = { 'swiftformat' },
        python = { 'black' },
        typescript = { 'prettier' },
        javascript = { 'prettier' },
        typescriptreact = { 'prettier' },
      },
      formatters = {
        black = {
          command = 'black',
          prepend_args = {
            '--line-length',
            '150',
          },
        },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      ignore_install = { 'swift' }, -- swift ts grammar causes issues
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  { import = 'custom.plugins' },
}, {

  -- Disable 'Change detected...' thing because it's annoying
  change_detection = { notify = false },

  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Install this plugin "manually" so I can comment out easily the keymaps I don't want
vim.cmd('source ' .. vim.fn.stdpath 'config' .. '/lua/custom/unimpaired.vim')

vim.keymap.set({ 'n', 'v' }, '<C-e>', '5<C-e>', { desc = 'Move window up 5 lines at a time' })
vim.keymap.set({ 'n', 'v' }, '<C-y>', '5<C-y>', { desc = 'Move window down 5 lines at a time' })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- (Copied from NvChad)
-- empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
vim.keymap.set('n', 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move down', expr = true })
vim.keymap.set('n', 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })

local lspconfig = require 'lspconfig'
local util = lspconfig.util
lspconfig.sourcekit.setup {
  cmd = { 'sourcekit-lsp' },

  -- (This 'xcrun' technique seems to cause a slowdown on first startup, so I'm disabling it)
  -- cmd = {
  --   -- By using xcrun we make sure to use whichever version of the sourcekit-lsp tool is specified via xcode-select
  --   vim.trim(vim.fn.system 'xcrun -f sourcekit-lsp'),
  -- },
}

-- Use a block cursor in normal mode
vim.opt.guicursor = ''

vim.opt.termguicolors = true

vim.opt.linebreak = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Keep cursor centered when jumping up and down
-- vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'scroll down + center cursor' })
-- vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'scroll up + center cursor' })

vim.keymap.set('n', '<leader>cp', function()
  local filepath = vim.fn.expand '%:p'
  print(filepath)
  vim.fn.setreg('+', filepath)
end, { noremap = true, silent = true, desc = '[C]opy & print current [P]ath' })

-- TODO: Figure out why this is broken now?
-- vim.keymap.set('n', '<leader>pt', require('copilot.suggestion').toggle_auto_trigger, { desc = 'Toggle Co[P]ilot plugin [T]' })

-- Open current buffer's file in default editor (i.e. Xcode)
vim.keymap.set('n', '<leader>oe', function()
  vim.fn.jobstart('open "' .. vim.fn.expand '%' .. '"')
end, { noremap = true, silent = true, desc = '[O]pen current buffer in [E]xternal editor' })

-- Open current file in Xcode w/ Preview
vim.keymap.set('n', '<leader>xp', function()
  vim.fn.jobstart('osascript ~/.config/nvim/scripts/xcode_preview.scpt "' .. vim.fn.expand '%:p' .. '"')
end, { noremap = true, silent = true, desc = 'Open current buffer in [X]code [P]review' })
-- Open current buffer's file in Zed
vim.keymap.set('n', '<leader>oz', function()
  vim.fn.jobstart('zed "' .. vim.fn.expand '%' .. '"')
end, { noremap = true, silent = true, desc = 'Open in [Z]ed editor' })

-- Open current buffer's enclosing folder in Finder
vim.keymap.set('n', '<leader>of', function()
  vim.fn.jobstart('open -R "' .. vim.fn.expand '%' .. '"')
end, { noremap = true, silent = true, desc = "[Open] current buffer's enclosing folder in [F]inder" })

-- Trigger Xcode run command
vim.keymap.set('n', '<leader>xx', function()
  vim.fn.jobstart 'osascript ~/.config/nvim/scripts/xcode_run.scpt'
end, { noremap = true, silent = true, desc = 'Trigger Xcode to build+run current project' })
vim.keymap.set('n', '<leader>xb', function()
  vim.fn.jobstart 'osascript ~/.config/nvim/scripts/xcode_build.scpt'
end, { noremap = true, silent = true, desc = 'Trigger Xcode to build current project' })

vim.keymap.set('n', '<leader>dpr', function()
  require('dap-python').test_method()
end, { desc = '[D]ebug [P]ython [R]un' })
vim.keymap.set('n', '<leader>db', '<cmd> DapToggleBreakpoint <CR>', { desc = '[D]ebug [P]ython [R]un' })

-- Replace all tabs with spaces
vim.keymap.set('n', '<leader>ts', '<cmd>:%s/\t/  /g <CR>', { desc = '[T]abs to [S]paces' })

-- Yank to the blackhole register when using "change" motions
vim.keymap.set('n', 'c', '"_c', { noremap = true, silent = true })

-- Aerial keymaps
-- vim.keymap.set('n', '<leader>al', '<cmd>AerialToggle left<cr>', { desc = '[A]erial [L]eft sidebar [T]oggle' })
-- vim.keymap.set('n', '<leader>ar', '<cmd>AerialToggle right<cr>', { desc = '[A]erial [R]eft sidebar [T]oggle' })
-- vim.keymap.set('n', '<leader>af', '<cmd>AerialToggle float<cr>', { desc = '[A]erial [L]eft sidebar [T]oggle' })

-- After adding a top bar via the breadcrumbs plugin, this is necessary to bring back the nice
-- behavior of 'zz' to center then C-d to scroll so cursor is right at the top of the screen
vim.keymap.set('n', '<C-d>', '<C-d><C-y>', { noremap = true })

vim.keymap.set('n', '<leader><leader>', '<cmd>b#<cr>', { desc = 'Switch to alternate buffer' })

vim.keymap.set('n', '<leader>cD', function()
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then
    return
  end
  path = vim.fs.dirname(path)
  vim.fn.chdir(path)
end, { desc = "[C]hange [D]irectory to current file's location" })

vim.keymap.set('n', '<leader>cd', function()
  local root_names = {
    '.git',
    'deno.json',
    'package.json',
    '.node-version',
    '.ruby-version',
    'requirements.txt',
    'pyproject.toml',
  }
  local root_folders = {
    'daily_notes',
  }
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then
    return
  end
  path = vim.fs.dirname(path)

  local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
  local root_folder = vim.fs.find(root_folders, { path = path, upward = true })[1]

  if root_file == nil and root_folder == nil then
    return
  end

  local root = root_file and vim.fs.dirname(root_file) or root_folder
  vim.fn.chdir(root)
end, { desc = "[C]hange [D]irectory to current file's project root" })

-- Prevent transparency plugin from making the statusline transparent
vim.g.exclude_groups = {
  'StatusLine',
  'StatusLineNC',
}

-- Set the colorscheme
vim.g.lumen_light_colorscheme = 'e-ink'
vim.g.lumen_dark_colorscheme = 'embark'

if vim.o.background == 'light' then
  vim.cmd.colorscheme(vim.g.lumen_light_colorscheme)
else
  vim.cmd.colorscheme(vim.g.lumen_dark_colorscheme)
end

-- Apparently I'm supposed to do this after setting colorscheme
require('avante_lib').load()

-- Set cursor to a bright/highlight color when in insert mode
-- local wildmenu_hl = vim.api.nvim_get_hl_by_name('WildMenu', true).background
vim.api.nvim_set_hl(0, 'Cursor', { bg = 'red' })

-- Make cursor a block in insert mode
vim.api.nvim_set_option_value('guicursor', 'i:block-Cursor/lCursor', { scope = 'global' }) --

-- Specify the path to the python interpreter because apparently it takes 1-2s to find it on startup :(
vim.g.python3_host_prog = vim.fn.expand 'which python3'

-- This needs to be called manually, it seems, even though LazyVim already does it
require('breadcrumbs').setup()

-- Fugitive and Gitsigns conflict when trying to use :G
-- So define G explicitly to be :Git
vim.api.nvim_create_user_command('G', function(opts)
  vim.cmd('Neogit ' .. opts.args)
end, { nargs = '*' })

vim.keymap.set('n', '<leader>lr', vim.diagnostic.reset, { desc = '[L]sp diagnostics [R]eset' })

-- Build DesignKit's icons
vim.keymap.set('n', '<leader>bi', function()
  local spinner = { '|', '/', '-', '\\' }
  local spinner_index = 1
  local timer = vim.loop.new_timer()

  local function update_spinner()
    print('\r' .. spinner[spinner_index] .. ' Building icons...')
    spinner_index = (spinner_index % #spinner) + 1
  end

  timer:start(0, 100, vim.schedule_wrap(update_spinner))

  vim.fn.jobstart('cd ~/code/joya/mp-desktop-web/shared/design-kit && npm run build', {
    on_exit = function(_, code)
      timer:stop()
      timer:close()
      vim.schedule(function()
        if code == 0 then
          print '\rBuild icons: Success   '
        else
          print '\rBuild icons: Failed   '
        end
      end)
    end,
  })
end, { desc = '[B]uild [I]cons' })

-- Open Icons Sprite Sheet in default editor
vim.keymap.set('n', '<leader>oi', function()
  local spritesheet_path = vim.fn.expand '~/code/joya/mp-desktop-web/shared/design-kit/generated/spritesheet-icons.svg'

  -- Check if file exists
  if vim.fn.filereadable(spritesheet_path) == 0 then
    print 'Sprite sheet not found. Try building icons first with <leader>bi'
    return
  end

  -- Open with default application
  if vim.fn.has 'mac' == 1 then
    vim.fn.jobstart('open ' .. spritesheet_path, { detach = true })
  elseif vim.fn.has 'unix' == 1 then
    vim.fn.jobstart('xdg-open ' .. spritesheet_path, { detach = true })
  elseif vim.fn.has 'win32' == 1 then
    vim.fn.jobstart('start "" "' .. spritesheet_path .. '"', { detach = true })
  end

  print 'Opening sprite sheet in default editor'
end, { desc = '[O]pen [I]cons sprite sheet' })

vim.keymap.set('n', '<leader>fa', ':!swiftformat .<CR>', { desc = '[F]ormat [A]ll files in directory' })

vim.keymap.set('n', '<leader>lf', function()
  local filepath = vim.fn.expand '%:p'
  local scheme = ''
  if string.find(filepath, 'Tofu Mobile') then
    scheme = 'Tofu Mobile'
  elseif string.find(filepath, 'Tofu Desktop') then
    scheme = 'Tofu Desktop'
  end
  if scheme ~= '' then
    vim.fn.chdir(vim.fn.expand '~/code/joya/sdr/client/real_backend/')

    local spinner = { '|', '/', '-', '\\' }
    local spinner_index = 1
    local timer = vim.loop.new_timer()

    local function update_spinner()
      print('\r' .. spinner[spinner_index] .. ' Switching xcode to scheme: ' .. scheme)
      spinner_index = (spinner_index % #spinner) + 1
    end

    timer:start(0, 100, vim.schedule_wrap(update_spinner))

    local function on_exit(_, code)
      timer:stop()
      timer:close()
      if code == 0 then
        print('\rSwitched xcode to scheme: ' .. scheme .. '   ')
      else
        print('\rxcode-build-server config failed with code: ' .. code .. '   ')
      end
    end

    if scheme == 'Tofu Mobile' then
      vim.fn.jobstart('xcode-build-server config -project *xcodeproj -scheme "Tofu Mobile"', { on_exit = on_exit })
    elseif scheme == 'Tofu Desktop' then
      vim.fn.jobstart('xcode-build-server config -project *xcodeproj -scheme "Tofu Desktop"', { on_exit = on_exit })
    end
  end
end, { desc = 'Fix (Swift) LSP by re-running xcode build tool' })

-- vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})
