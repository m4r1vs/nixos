-- Tools for browsing Obsidian Markdown files
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>so",
      "<cmd>ObsidianQuickSwitch<cr>",
      desc = "Search Obsidian notes",
      mode = { "n" }
    },
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "/home/mn/Documents/Marius' Remote Vault",
      },
    },
    disable_frontmatter = true,
    daily_notes = {
      folder = "Journal",
      date_format = "%Y-%m-%d",
    },
    templates = {
      folder = "Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },
    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      vim.ui.open(url) -- need Neovim 0.10.0+
    end,
  },
}
