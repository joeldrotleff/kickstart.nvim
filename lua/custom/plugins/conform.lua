return {
  -- Autoformat
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
} 