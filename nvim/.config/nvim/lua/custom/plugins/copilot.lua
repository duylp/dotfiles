return {
  'github/copilot.vim',

  config = function()
    -- Accept next word of suggestion with Alt+w
    vim.keymap.set('i', '<M-w>', '<Plug>(copilot-accept-word)', { desc = 'Copilot: Accept next word' })

    -- Accept next line of suggestion with Alt+l
    vim.keymap.set('i', '<M-l>', '<Plug>(copilot-accept-line)', { desc = 'Copilot: Accept next line' })

    -- Available Copilot <Plug> mappings (with their defaults):
    --   <Plug>(copilot-accept)     - Accept full suggestion       (default: <Tab>)
    --   <Plug>(copilot-suggest)    - Explicitly request suggestion (default: none)
    --   <Plug>(copilot-dismiss)    - Dismiss current suggestion    (default: <C-]>)
    --   <Plug>(copilot-next)       - Cycle to next suggestion      (default: <M-]>)
    --   <Plug>(copilot-previous)   - Cycle to previous suggestion  (default: <M-[>)
  end,
}
