-- https://github.com/folke/snacks.nvim
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = {
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
    -- explorer = { enabled = true },
    image = { enabled = true },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    -- picker = { enabled = true },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- scope = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
    -- terminal = {
    --   bo = {
    --     filetype = "snacks_terminal",
    --   },
    --   wo = {},
    --   keys = {
    --     q = "hide",
    --     gf = function(self)
    --       local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
    --       if f == "" then
    --         Snacks.notify.warn("No file under cursor")
    --       else
    --         self:hide()
    --         vim.schedule(function()
    --           vim.cmd("e " .. f)
    --         end)
    --       end
    --     end,
    --     term_normal = {
    --       "<esc>",
    --       function(self)
    --         self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
    --         if self.esc_timer:is_active() then
    --           self.esc_timer:stop()
    --           vim.cmd("stopinsert")
    --         else
    --           self.esc_timer:start(200, 0, function() end)
    --           return "<esc>"
    --         end
    --       end,
    --       mode = "t",
    --       expr = true,
    --       desc = "Double escape to normal mode",
    --     },
    --   },
    -- }
  },
  keys = {
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
  },
}
