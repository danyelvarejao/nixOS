return {
  {
    "catppuccin",
    opts = {
      term_colors = true,
      transparent_background = false,
      float = {
        transparent = false, -- enable transparent floating windows
      },
      color_overrides = {
        latte = {
          yellow = "#C9801D",
        },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },

  -- Colored bracket pairs
  { "HiPhish/rainbow-delimiters.nvim", event = "LazyFile" },

  -- edgy
  {
    "folke/edgy.nvim",
    opts = {
      options = {
        left = { size = 30 },
        bottom = { size = 10 },
        right = { size = 50 },
        top = { size = 10 },
      },
      animate = {
        enabled = false,
      },
    },
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        show_buffer_close_icons = false,
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_a = {
        {
          "mode",
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
      }
      opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path({ length = 6 }) }
      opts.sections.lualine_z = opts.sections.lualine_y
      opts.sections.lualine_y = opts.sections.lualine_x
      opts.sections.lualine_x = { "searchcount" }
    end,
  },
}
