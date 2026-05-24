-- Navigator.nvim
-- https://github.com/numToStr/Navigator.nvim

return {
  'numToStr/Navigator.nvim',
  config = function()
    require('Navigator').setup {
      -- Save current modified buffer when moving to mux
      auto_save = 'current',
      -- Disable navigation when the current mux pane is zoomed in
      disable_on_zoom = false,
    }

    -- Keybindings for seamless navigation between Neovim and WezTerm panes
    vim.keymap.set({ 'n', 't' }, '<C-h>', '<CMD>NavigatorLeft<CR>', { desc = 'Navigate Left' })
    vim.keymap.set({ 'n', 't' }, '<C-l>', '<CMD>NavigatorRight<CR>', { desc = 'Navigate Right' })
    vim.keymap.set({ 'n', 't' }, '<C-k>', '<CMD>NavigatorUp<CR>', { desc = 'Navigate Up' })
    vim.keymap.set({ 'n', 't' }, '<C-j>', '<CMD>NavigatorDown<CR>', { desc = 'Navigate Down' })
  end,
}
