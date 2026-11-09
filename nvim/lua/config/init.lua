-- Load or install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- https://www.lazyvim.org/configuration/lazy.nvim
local theme = "catppuccin-mocha"

require("lazy").setup({
  spec = {
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = theme,
        defaults = {
          autocmds = true,
          keymaps = true,
          options = true,
        },
      },
      import = "lazyvim.plugins",
    },
    { import = "plugins" },
  },
  install = { colorscheme = { theme } },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
