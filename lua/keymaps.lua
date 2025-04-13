-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

local show_diagnostics = function()
  vim.diagnostic.config { virtual_text = true, virtual_lines = true }
end
local hide_diagnostics = function()
  vim.diagnostic.config { virtual_text = false, virtual_lines = false }
end

-- Keymaps for toggling what shows for virtual text
vim.keymap.set('n', '<leader>vs', show_diagnostics, { desc = '[V]irtualtext/Diagnostics [S]how' })
vim.keymap.set('n', '<leader>vh', hide_diagnostics, { desc = '[V]irtualtext/Diagnostics [H]ide' })

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- (Copied from NvChad)
-- empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
vim.keymap.set('n', 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move down', expr = true })
vim.keymap.set('n', 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })

-- Keep cursor centered when jumping up and down
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'scroll down + center cursor' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'scroll up + center cursor' })

-- Copy current file path to clipboard and print it
vim.keymap.set('n', '<leader>cp', function()
  local filepath = vim.fn.expand '%:p'
  print(filepath)
  vim.fn.setreg('+', filepath)
end, { noremap = true, silent = true, desc = '[C]opy & print current [P]ath' })

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

-- Trigger Xcode build command
vim.keymap.set('n', '<leader>xb', function()
  vim.fn.jobstart 'osascript ~/.config/nvim/scripts/xcode_build.scpt'
end, { noremap = true, silent = true, desc = 'Trigger Xcode to build current project' })

-- Replace all tabs with spaces
vim.keymap.set('n', '<leader>ts', '<cmd>:%s/\t/  /g <CR>', { desc = '[T]abs to [S]paces' })

-- Yank to the blackhole register when using "change" motions
vim.keymap.set('n', 'c', '"_c', { noremap = true, silent = true })

vim.keymap.set('n', '<C-d>', '<C-d><C-y>', { noremap = true })

-- Switch to alternate buffer
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

vim.keymap.set('n', '<leader>fa', ':!swiftformat .<CR>', { desc = '(swiftformat) [F]ormat [A]ll files in directory' })

local fix_lsp = function()
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
end
vim.keymap.set('n', '<leader>lf', fix_lsp, { desc = 'Fix (Swift) LSP by re-running xcode build tool' })
