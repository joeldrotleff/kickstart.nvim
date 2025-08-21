-- Load the entirety of the current buffer
local function loadEntireBuffer()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  return lines
end

--- Split a string by lines
--- @param str string
--- @return table
local function splitStringByLines(str)
  local t = {}
  for line in str:gmatch '([^\n]+)' do
    table.insert(t, line)
  end
  return t
end

--- Get the text of the visual selection
--- @return table
local function getVisualSelection()
  local original_reg_v = vim.fn.getreg 'v'
  vim.api.nvim_command 'normal! "vy'
  local content = vim.fn.getreg 'v'
  vim.fn.setreg('v', original_reg_v)
  return splitStringByLines(content)
end

--- Looks for special comments of the form `-- #<ALL_CAPS_VARIABLE>: <expression>` and uses them to replace
--- the corresponding `$<ALL_CAPS_VARIABLE>`. I.e. if the comment gives #USER_ID: 123-456, and the query
-- is 'SELECT name FROM users WHERE users.id = $USER_ID, then this function would alter the query to be:
-- SELECT NAME FROM USERS WHERE users.id = 123-456.
--
-- Additionally, it removes all comments from the query, and concatenates it into a single string, being careful
-- to add padding spaces to account for removal of newlines (i.e. SELECT\nname becomes SELECT name instead of SELECTname)
--
-- (The reason to use #USER_IDS in comments instead of $USER_IDS is to avoid the query being altered by the
-- our PostgreSQL library, which would try to replace $USER_IDS with a value from the calling function)
--
--
-- @param lines table
-- @return string
local function replaceParamsUsingComments(lines)
  local paramReplacements = {}
  local commentsRemoved = {}

  for _, line in ipairs(lines) do
    local paddedLine = ' ' .. line .. ' '
    local param, paramReplacement = paddedLine:match '-- #([%u%d_]+): (.*)'
    if param and paramReplacement then
      paramReplacements[param] = paramReplacement
    else
      if not paddedLine:match '^%s*%-%-' then
        table.insert(commentsRemoved, paddedLine)
      end
    end
  end

  local processedQuery = table.concat(commentsRemoved):gsub('%$([%u%d_]+)', function(k)
    return paramReplacements[k] or ('$' .. k)
  end)
  -- Remove newlines and consecutive spaces
  -- processedQuery = processedQuery:gsub("[\n\r]+", " "):gsub("%s%s+", " ")
  return processedQuery
end

--- Grab the current query based on cursor position (if in normal mode) or the visual selection (if in visual mode)
--- and send it to the dadbod plugin (which runs the query and displays the results in a split window)
local function send_to_dadbod(visual_mode)
  local query
  if visual_mode then
    query = getVisualSelection()
  else
    query = loadEntireBuffer()
  end
  local processedQuery = replaceParamsUsingComments(query)
  vim.cmd('DB ' .. processedQuery)
end

local M = {}

M.setup = function()
  vim.keymap.set('n', '<leader>qq', function()
    send_to_dadbod(false)
  end, { noremap = true, silent = true })
  vim.keymap.set('x', '<leader>qq', function()
    send_to_dadbod(true)
  end, { noremap = true, silent = true })
end

return {
  -- 'tpope/vim-dadbod',
  -- event = 'VeryLazy',
  -- dependencies = {
  --   'kristijanhusak/vim-dadbod-ui',
  --   'kristijanhusak/vim-dadbod-completion',
  -- },
  -- config = function()
  --   -- NOTE! Dadbod uses the $DATABASE_URL environment variable to connect to the database.
  --   -- If it isn't set it causes a nasty error whenever opening a SQL file.
  --   vim.api.nvim_create_autocmd('FileType', {
  --     pattern = { 'sql', 'mysql', 'plsql' },
  --     callback = function()
  --       local success, err = pcall(function()
  --         require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
  --       end)
  --       if not success then
  --         print 'Error setting up database autocopmlete'
  --       end
  --     end,
  --   })
  --
  --   M.setup()
  --   -- require('custom.dadbod-enhancements').setup()
  -- end,
}
