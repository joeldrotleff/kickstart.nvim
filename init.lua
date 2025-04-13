-- Install Lazy.nvim for plugin management
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require 'settings'
require 'keymaps'

require('lazy').setup {
  spec = {
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
        -- LSP Configuration
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
          callback = function(event)
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end

            local builtin = require 'telescope.builtin'
            map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
            map('gD', function()
              builtin.lsp_definitions { jump_type = 'vsplit' }
            end, '[G]oto [Definition] in new split')
            map('gr', builtin.lsp_references, '[G]oto [R]eferences')
            map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
            map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
            map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
            map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            local client_id = event.data.client_id
            local client = client_id and vim.lsp.get_client_by_id(client_id)
            if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

            if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, '[T]oggle Inlay [H]ints')
            end
          end,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
        local lspconfig = require 'lspconfig'

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

        lspconfig.denols.setup {
          root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
          cmd = { 'deno', 'lsp' },
        }

        lspconfig.ts_ls.setup {
          root_dir = lspconfig.util.root_pattern 'tsconfig.json',
          single_file_support = false,
        }

        lspconfig.sourcekit.setup {
          cmd = { 'sourcekit-lsp' },
        }
      end,
    },

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    This is the easiest way to modularize your config.
    { import = 'custom.plugins' },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    missing = true,
  },
  checker = {
    enabled = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
  },
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
}

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

-- Install this plugin "manually" so I can comment out easily the keymaps I don't want
vim.cmd('source ' .. vim.fn.stdpath 'config' .. '/lua/custom/unimpaired.vim')

-- Fugitive and Gitsigns conflict when trying to use :G
-- So define G explicitly to be :Git
vim.api.nvim_create_user_command('G', function(opts)
  vim.cmd('Neogit ' .. opts.args)
end, { nargs = '*' })

-- Note to future Joel:
-- Directory where chatgpt saves session files
-- Sometimes they get corrupt so I just rm rf this direcotyr
-- $HOME/.local/state/nvim/chatgpt

-- Set colorscheme
vim.cmd [[colorscheme kanagawa]]
