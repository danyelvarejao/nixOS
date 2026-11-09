local large = {
  width = 0.95,
  height = 0.9,
}
local full = {
  width = 0,
  height = 0,
}
local layout_full = { layout = { fullscreen = true } }

return {
  {
    "folke/snacks.nvim",
    opts = {
      styles = {
        lazygit = full,
        blame_line = large,
        notification_history = large,
      },
      picker = {
        sources = {
          gh_issue = layout_full,
          gh_pr = layout_full,
          gh_diff = {
            ignore_whitespace = true,
            layout = { fullscreen = true },
          },
          git_diff = layout_full,
          explorer = {
            layout = {
              layout = {
                position = "right",
              },
            },
          },
        },
      },
      terminal = {
        wo = {
          winhighlight = "Normal:Normal",
        },
      },
      image = {},
      lazygit = {
        configure = true,
        config = {
          os = { editPreset = "nvim-remote" },
        },
      },
      gh = {
        wo = {
          winhighlight = "Normal:Normal",
        },
      },
      bigfile = {},
    },
  },
}
