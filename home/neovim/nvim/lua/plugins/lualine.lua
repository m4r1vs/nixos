-- Show information about current session in a line below
if vim.g.started_by_firenvim == true then
  return {}
else
  return {
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = "VeryLazy",
      init = function()
        local lualine = require("lualine")

        -- Color table for highlights
        -- stylua: ignore
        local colors = {
          bg       = '#202328',
          fg       = '#bbc2cf',
          yellow   = '#ECBE7B',
          cyan     = '#008080',
          darkblue = '#081633',
          green    = '#98be65',
          orange   = '#FF8800',
          violet   = '#a9a1e1',
          magenta  = '#c678dd',
          blue     = '#51afef',
          red      = '#ec5f67',
        }

        local conditions = {
          buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
          end,
          hide_in_width = function()
            return vim.fn.winwidth(0) > 80
          end,
          check_git_workspace = function()
            local filepath = vim.fn.expand("%:p:h")
            local gitdir = vim.fn.finddir(".git", filepath .. ";")
            return gitdir and #gitdir > 0 and #gitdir < #filepath
          end,
        }

        local config = {
          options = {
            component_separators = "",
            section_separators = "",
            theme = "auto",
            globalstatus = true,
            disabled_filetypes = { "alpha" }
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {},
            lualine_x = {},
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {},
            lualine_x = {},
          },
        }

        local function ins_left(component)
          table.insert(config.sections.lualine_c, component)
        end

        local function ins_right(component)
          table.insert(config.sections.lualine_x, component)
        end

        -- ins_left({
        --   function()
        --     return string.format(" %s", vim.fn.mode())
        --   end,
        --   color = function()
        --     local mode_color = {
        --       n = colors.red,
        --       i = colors.green,
        --       v = colors.blue,
        --       ["␖"] = colors.blue,
        --       V = colors.blue,
        --       c = colors.magenta,
        --       no = colors.red,
        --       s = colors.orange,
        --       S = colors.orange,
        --       ["␓"] = colors.orange,
        --       ic = colors.yellow,
        --       R = colors.violet,
        --       Rv = colors.violet,
        --       cv = colors.red,
        --       ce = colors.red,
        --       r = colors.cyan,
        --       rm = colors.cyan,
        --       ["r?"] = colors.cyan,
        --       ["!"] = colors.red,
        --       t = colors.red,
        --     }
        --     if mode_color[vim.fn.mode()] == nil then
        --       return { fg = colors.blue }
        --     end
        --     return { fg = mode_color[vim.fn.mode()] }
        --   end,
        --   padding = { right = 1 },
        -- })

        -- ins_left({
        --   "filename",
        --   cond = conditions.buffer_not_empty,
        --   color = { fg = colors.magenta, gui = "bold" },
        --   file_status = true,
        --   path = 3,
        -- })

        ins_left({
          function()
            return require("auto-session.lib").current_session_name(false)
          end,
          color = { fg = colors.magenta, gui = "bold" },
        })

        ins_left({ "location" })

        ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

        ins_left({
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " " },
          diagnostics_color = {
            color_error = { fg = colors.red },
            color_warn = { fg = colors.yellow },
            color_info = { fg = colors.cyan },
          },
        })

        ins_right({
          function()
            local msg = "None"
            local buf_ft = vim.api.nvim_get_option_value("filetype", {
              buf = 0
            })
            local clients = vim.lsp.get_clients()
            if next(clients) == nil then
              return msg
            end
            for _, client in ipairs(clients) do
              local filetypes = client.config.filetypes
              if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
              end
            end
            return msg
          end,
          icon = "󰌵",
          color = { fg = colors.yellow, gui = "bold" },
        })

        ins_right({
          "o:encoding",
          fmt = string.upper,
          cond = conditions.hide_in_width,
          color = { fg = colors.green, gui = "bold" },
        })

        ins_right({
          "fileformat",
          fmt = string.upper,
          icons_enabled = false,
          color = { fg = colors.green, gui = "bold" },
        })

        ins_right({
          "branch",
          icon = "",
          color = { fg = colors.violet, gui = "bold" },
        })

        ins_right({
          "diff",
          symbols = { added = " ", modified = "󰝤 ", removed = " " },
          diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.orange },
            removed = { fg = colors.red },
          },
          cond = conditions.hide_in_width,
        })

        lualine.setup(config)
      end,
    },
  }
end
