return {
  'joeldrotleff/ChatGPT.nvim',
  branch = 'main',
  event = 'VeryLazy',
  config = function()
    require('chatgpt').setup {
      openai_params = {
        model = 'gpt-4o',
        max_tokens = 4096,
      },
      predefined_chat_gpt_prompts = '~/Documents/custom-chatgpt-prompts.csv',
    }

    vim.keymap.set('n', '<leader>gg', ':ChatGPT<CR>')
    vim.keymap.set('n', '<leader>ga', ':ChatGPTActAs<CR>')
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
  },
}
