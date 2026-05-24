-- https://github.com/coder/claudecode.nvim
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = {
      split_width_percentage = 0.4,
    },
  },
  keys = {
    { "<Leader>k", nil, desc = "AI/Claude Code" },
    { "<Leader>kk", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<Leader>kf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<Leader>kR", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<Leader>kC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<Leader>km", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<Leader>kb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<Leader>ks", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<Leader>ks",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    { "<Leader>ka", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<Leader>kr", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
  },
}
