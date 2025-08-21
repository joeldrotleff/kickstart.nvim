local M = {}

-- Parse aliases.fish to extract directory aliases
function M.setup()
  local aliases_file = vim.fn.expand("~/.config/fish/aliases.fish")
  local file = io.open(aliases_file, "r")
  
  if not file then
    vim.notify("Could not open aliases.fish", vim.log.levels.WARN)
    return
  end
  
  local count = 0
  for line in file:lines() do
    -- Skip comments and empty lines
    if not line:match("^#") and line ~= "" then
      -- Pattern to match: alias @NAME 'cd PATH'
      local name, path = line:match("alias @(%w+) 'cd ([^']+)'")
      if name and path then
        -- Create uppercase Neovim command for each alias
        local cmd_name = name:upper()
        local expanded_path = vim.fn.expand(path)
        
        vim.api.nvim_create_user_command(cmd_name, function()
          vim.cmd("cd " .. expanded_path)
          print("→ " .. expanded_path)
        end, {})
        count = count + 1
      end
    end
  end
  
  file:close()
end

-- Create a reload command
vim.api.nvim_create_user_command("ReloadAliases", function()
  M.setup()
end, {})

return M
