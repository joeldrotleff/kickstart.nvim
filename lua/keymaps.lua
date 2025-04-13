-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

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


vim.keymap.set({ 'n', 'v' }, '<C-e>', '5<C-e>', { desc = 'Move window up 5 lines at a time' })
vim.keymap.set({ 'n', 'v' }, '<C-y>', '5<C-y>', { desc = 'Move window down 5 lines at a time' })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- (Copied from NvChad)
-- empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
vim.keymap.set('n', 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move down', expr = true })
vim.keymap.set('n', 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })


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

vim.keymap.set('n', '<leader>fa', ':!swiftformat .<CR>', { desc = '[F]ormat [A]ll files in directory' })

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
