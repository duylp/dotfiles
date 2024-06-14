-- goto-preview
-- https://github.com/rmagatti/goto-preview

return {
  'rmagatti/goto-preview',
  config = function()
    require('goto-preview').setup {
      width = 120,
      height = 15,
      default_mappings = true,
      debug = false,
      opacity = nil,
    }
  end,
}
