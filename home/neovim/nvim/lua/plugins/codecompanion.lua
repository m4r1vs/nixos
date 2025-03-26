-- Complex UI for interacting with Large Language Models.
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>ta", "<cmd>CodeCompanionActions<cr>",     mode = "n" },
    { "<leader>ta", "<cmd>CodeCompanionActions<cr>",     mode = "v" },
    { "<leader>tt", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n" },
    { "<leader>tt", "<cmd>CodeCompanionChat Toggle<cr>", mode = "v" },
    { "<leader>tl", "<cmd>CodeCompanionChat Add<cr>",    mode = "v" },
    {
      "<leader>te",
      "",
      callback = function()
        require("codecompanion").prompt("explain")
      end,
      mode = "v"
    },
  },
  opts = {
    display = {
      diff = {
        provider = "mini_diff",
      },
    },
    strategies = {
      chat = {
        adapter = "gemini",
        roles = {
          llm = "Language Model 󰅏",
          user = "Input Prompt ",
        },
      },
    },
    adapters = {
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          env = {
            api_key = "cmd: op read op://Employee/OpenAI/credential",
          },
          schema = {
            model = {
              default = "gpt-4.5-preview",
            },
          },
        })
      end,
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "cmd: op read op://Employee/Gemini/credential",
          },
          schema = {
            model = {
              default = "gemini-2.5-pro-exp-03-25",
            },
          },
        })
      end,
    },
  }
}
