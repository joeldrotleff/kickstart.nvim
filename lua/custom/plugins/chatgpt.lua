return {
  'joeldrotleff/ChatGPT.nvim',
  branch = 'main',
  event = 'VeryLazy',
  opts = {
    openai_params = {
      model = 'gpt-4.1-2025-04-14',
      max_tokens = 4096,
    },
    predefined_chat_gpt_prompts = '~/Documents/custom-chatgpt-prompts.csv',
  },
  keys = {
    { '<leader>gg', ':ChatGPT<CR>', desc = 'Open Chat[GG]PT prompt menu' },
    { '<leader>ga', ':ChatGPTActAs<CR>', desc = 'Open Chat[G]PT [A]ct as menu' },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'folke/trouble.nvim', -- optional
    'nvim-telescope/telescope.nvim',
  },
}
