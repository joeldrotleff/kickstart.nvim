return {
  'Exafunction/codeium.vim',
	enabled = false,
  config = function()
    vim.g.codeium_disable_bindings = 1

    vim.g.codeium_filetypes = {
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
    }

    vim.keymap.set('i', '<m-l>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true })
    vim.keymap.set('i', '<m-;>', function()
      return vim.fn['codeium#CycleCompletions'](1)
    end, { expr = true, silent = true })
    vim.keymap.set('i', '<m-,>', function()
      return vim.fn['codeium#CycleCompletions'](-1)
    end, { expr = true, silent = true })
    vim.keymap.set('i', '<m-x>', function()
      return vim.fn['codeium#Clear']()
    end, { expr = true, silent = true })
  end,
}
