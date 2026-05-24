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
    -- {
    --   "Davidyz/VectorCode", -- Index and search code in your repositories
    --   version = "*",
    --   build = "pipx upgrade vectorcode",
    --   dependencies = { "nvim-lua/plenary.nvim" },
    -- },
  },
  opts = {
    prompt_library = {
      markdown = {
        dirs = {
          "~/.config/nvim/lua/custom/plugins/prompts",
        },
      },
    },
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_tools = true,              -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
          show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
          add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
          make_vars = false, -- Disabled: mcphub hasn't updated for codecompanion v18+ (variables -> editor_context)
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
      -- vectorcode = {
      --   opts = {
      --     add_tool = true,
      --   },
      -- },
    },
    display = {
      chat = {
        window = {
          layout = "vertical", -- float|vertical|horizontal|buffer
          height = 1.0,
          width = 0.5,
        },
      },
      diff = {
        provider_opts = {
          inline = {
              layout = "buffer", -- "buffer" | "float"
          },
        },
      },
    },
    adapters = {
      http = {
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
                  default = "anthropic/claude-opus-4.6",
                },
              },
          })
        end,
      },
    },
    interactions = {
      -- Change the default chat adapter
        chat = {
          tools = {
            opts = {
              auto_submit_errors = true,  -- Send any errors to the LLM automatically
              auto_submit_success = true, -- Send any successful output to the LLM automatically
            },
          },
          adapter = {
            name = "openrouter",
            model = "anthropic/claude-opus-4.6",

          },
        },
        inline = {
          adapter = {
            name = "openrouter",
            model = "anthropic/claude-opus-4.6",
          },
        },
        cmd = {
          adapter = {
            name = "openrouter",
            model = "anthropic/claude-opus-4.6",
          },
        },
        cli = {
          agent = "claude_code",
          agents = {
            claude_code = {
              cmd = "claude",
              args = {},
              description = "Claude Code CLI",
              provider = "terminal",
            },
          },
          opts = {
            auto_insert = true, -- Enter insert mode when focusing the CLI terminal
            reload = true,      -- Reload buffers when an agent modifies files on disk
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
      function()
        require("codecompanion").toggle()
      end,
      desc = "Toggle Code Companion",
      mode = { "n", "v" },
    },
    {
      "<LocalLeader>cp",
      function()
        require("codecompanion").cli({ prompt = true })
      end,
      desc = "Prompt CLI agent",
      mode = { "n", "v" },
    },
    {
      "<LocalLeader>cd",
      function()
        require("codecompanion").cli("#{diagnostics} Can you fix these?", { focus = false, submit = true })
      end,
      desc = "Send diagnostics to CLI",
      mode = "n",
    },
    {
      "<LocalLeader>ca",
      function()
        require("codecompanion").cli("#{this}", { focus = false })
      end,
      desc = "Add context to CLI",
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
