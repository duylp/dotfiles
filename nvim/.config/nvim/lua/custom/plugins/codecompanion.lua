return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "j-hui/fidget.nvim", -- Display status updates
    {
      "ravitemer/mcphub.nvim", -- Manage MCP servers
      cmd = "MCPHub",
      build = "npm install -g mcp-hub@latest",
      config = true,
    },
    {
      "Davidyz/VectorCode", -- Index and search code in your repositories
      version = "*",
      build = "pipx upgrade vectorcode",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
  },
  opts = {
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_tools = true,              -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
          show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
          add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
      vectorcode = {
        opts = {
          add_tool = true,
        },
      },
    },
    adapters = {
      openrouter = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          name = "openrouter",
          formatted_name = "OpenRouter",
          env = {
            url = "https://openrouter.ai/api",
            api_key = "cmd: echo $OPENROUTER_API_KEY",
            chat_url = "/v1/chat/completions",
          },
          schema = {
            model = {
              default = "anthropic/claude-sonnet-4",
              -- default = "moonshotai/kimi-k2",
            },
          },
        })
      end,
    },
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = {
          name = "openrouter",
          model = "anthropic/claude-sonnet-4",
          -- model = "moonshotai/kimi-k2",
        },
      },
      inline = {
        adapter = {
          name = "openrouter",
          model = "anthropic/claude-sonnet-4",
          -- model = "moonshotai/kimi-k2",
        },
      },
      cmd = {
        adapter = {
          name = "openrouter",
          model = "anthropic/claude-sonnet-4",
          -- model = "moonshotai/kimi-k2",
        },
      },
    },
    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },
  },
  keys = {
    {
      "<Leader>cc",
      "<cmd>CodeCompanionActions<cr>",
      desc = "Code Companion Actions",
      mode = { "n", "v" },
    },
    {
      "<LocalLeader>a",
      "<cmd>CodeCompanionChat Toggle<cr>",
      desc = "Toggle Code Companion Chat",
      mode = { "n", "v" },
    },
    {
      "ga",
      "<cmd>CodeCompanionChat Add<cr>",
      desc = "Add Code Companion Chat",
      mode = "v",
    },
  },
  init = function()
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab cca CodeCompanionActions]])
  end,
}
