return {
  'LunarVim/breadcrumbs.nvim',
  dependencies = {
    {
      'SmiteshP/nvim-navic',
      opts = {
        lsp = {
          auto_attach = true,
        },
      },
    },
  },
}
