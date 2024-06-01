local function is_xcode_project_file(path)
  local valid_extensions = {
    '.swift',
    '.txt',
    '.m',
    '.h',
    '.mm',
    '.c',
    '.cpp',
    '.xib',
    '.storyboard',
    '.plist',
    '.xcassets',
    '.entitlements',
    '.strings',
    '.xcdatamodeld',
    '.framework',
    '.a',
    '.bundle',
    '.metal',
  }
  local extension = path:match '^.+(%..+)$'
  for _, ext in ipairs(valid_extensions) do
    if ext == extension then
      return true
    end
  end
  return false
end

return {
  'wojciech-kulik/xcodebuild.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-tree.lua',
  },
  config = function()
    require('xcodebuild').setup {
      integrations = {
        nvim_tree = {
          enabled = true,
          should_update_project = function(path)
            return is_xcode_project_file(path)
          end,
        },
      },
    }
  end,
}