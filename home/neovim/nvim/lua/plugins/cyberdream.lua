-- Nice transparent neovim theme
return {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    italic_comments = true,
    hide_fillchars = true,
    borderless_pickers = true,
    cache = false,
    variant = "auto",
    highlights = {
      TabLineSel = { fg = "#000000", bg = "#DA698D" },
      IblScope = { fg = "#DA698D", bg = "NONE" },
      LeapLabelPrimary = { fg = "#000000", bg = "#eb8aa9", bold = true },
      AlphaHeader = { fg = "#DA698D", bg = "NONE" },
    },
    extensions = {
      telescope = true,
      leap = false,
      mini = true,
      gitsigns = true,
      lazy = true,
      trouble = true,
      treesitter = true,
      base = true,
    }
  }
}
