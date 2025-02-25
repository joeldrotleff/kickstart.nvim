return {
  'yetone/avante.nvim',
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = 'claude',
    auto_suggestions_provider = 'claude',
    cursor_applying_provider = nil,
    claude = {
      endpoint = 'https://api.anthropic.com',
      model = 'claude-3-7-sonnet-20250219',
      temperature = 0,
      max_tokens = 4096,
    },

    hints = { enabled = true },
    -- recommended settings
    default = {
      embed_image_as_base64 = false,
      prompt_for_file_name = false,
      drag_and_drop = {
        insert_mode = true,
      },
      -- required for Windows users
      use_absolute_path = true,
    },
    windows = {
      ask = { floating = true },
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  dependencies = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'Avante' },
      },
      ft = { 'Avante' },
    },
  },
}
