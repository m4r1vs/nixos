-- Quickly leap from point-to-point
return {
  "ggandor/leap.nvim",
  name = "leap",
  event = "VeryLazy",
  init = function()
    require("leap").add_default_mappings()
    vim.keymap.set({ "n", "o" }, "gS", function()
      require("leap.remote").action()
    end)
  end,
}
