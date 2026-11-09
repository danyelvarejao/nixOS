local layouts = require("snacks.picker.config.layouts")
layouts.full_horiz = {
  reverse = true,
  layout = {
    box = "horizontal",
    width = 0.95,
    height = 0.9,
    border = "none",
    {
      box = "vertical",
      { win = "list", title = " Results ", title_pos = "center", border = "none" },
      { win = "input", height = 1, border = "none", title = "{title} {live} {flags}", title_pos = "center" },
    },
    {
      win = "preview",
      title = "{preview:Preview}",
      width = 0.6,
      border = "none",
      title_pos = "center",
    },
  },
}
layouts.full_vert = {
  layout = {
    backdrop = false,
    fullscreen = true,
    box = "vertical",
    border = "rounded",
    title = "{title} {live} {flags}",
    title_pos = "center",
    { win = "input", height = 1, border = "bottom" },
    { win = "list", border = "none" },
    { win = "preview", title = "{preview}", height = 0.4, border = "top" },
  },
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = {
          --- Use the default layout or vertical if the window is too narrow
          preset = function()
            return vim.o.columns >= 120 and "full_horiz" or "full_vert"
          end,
        },
      },
    },
  },
}
