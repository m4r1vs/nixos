-- Automatically run the configured formatter on save
return {
  "elentok/format-on-save.nvim",
  event = "VeryLazy",
  init = function()
    local format_on_save = require("format-on-save")
    local formatters = require("format-on-save.formatters")

    format_on_save.setup({
      stderr_loglevel = vim.log.levels.OFF,
      exclude_path_patterns = {
        "/node_modules/",
        ".local/share/nvim/lazy",
      },
      formatter_by_ft = {
        css = formatters.prettierd,
        html = formatters.lsp,
        java = formatters.lsp,
        json = formatters.lsp,
        lua = formatters.lsp,
        toml = formatters.lsp,
        markdown = formatters.prettierd,
        openscad = formatters.lsp,
        rust = formatters.lsp,
        scad = formatters.lsp,
        scss = formatters.prettierd,
        sh = formatters.shfmt,
        terraform = formatters.lsp,
        typescript = formatters.prettierd,
        typescriptreact = formatters.prettierd,
        yaml = formatters.lsp,
        dart = formatters.lsp,
        tex = formatters.lsp,
        c = formatters.lsp,

        nix = {
          formatters.shell({ cmd = { "alejandra" } })
        },

        -- https://github.com/Enter-tainer/typstyle/
        typst = {
          formatters.shell({ cmd = { "typstyle" } })
        },

        -- Concatenate formatters
        python = {
          formatters.remove_trailing_whitespace,
          formatters.black,
        },

        go = {
          formatters.shell({ cmd = { "goimports" } })
        },

        -- Add conditional formatter that only runs if a certain file exists
        -- in one of the parent directories.
        javascript = {
          formatters.if_file_exists({
            pattern = ".eslintrc.*",
            formatter = formatters.eslint_d_fix,
          }),
          formatters.if_file_exists({
            pattern = { ".prettierrc", ".prettierrc.*", "prettier.config.*" },
            formatter = formatters.prettierd,
          }),
          -- By default it stops at the git repo root (or "/" if git repo not found)
          -- but it can be customized with the `stop_path` option:
          formatters.if_file_exists({
            pattern = ".prettierrc",
            formatter = formatters.prettierd,
            stop_path = function()
              return "/my/custom/stop/path"
            end,
          }),
        },
        fallback_formatter = {
          formatters.remove_trailing_whitespace,
          formatters.remove_trailing_newlines,
        },
      }
    })
  end
}
