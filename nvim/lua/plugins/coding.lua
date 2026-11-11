return {
  -- swap arguments and things
  { "mizlan/iswap.nvim", opts = {} },

  -- autocompletion https://www.lazyvim.org/extras/coding/blink
  {
    "saghen/blink.cmp",
    dependencies = {
      -- autocomplete issues and PRs from GitHub
      { "Kaiser-Yang/blink-cmp-git" },
    },
    opts = {
      sources = {
        default = { "git", "lsp", "buffer", "path" },
        providers = {
          git = {
            module = "blink-cmp-git",
            name = "Git",
            opts = {
              commit = {
                -- removed `:` to prevent false positives
                triggers = {},
              },
            },
          },
        },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 50,
          update_delay_ms = 50,
        },
        ghost_text = {
          enabled = true,
        },
      },
    },
  },

  -- brought by blink.cmp
  { "rafamadriz/friendly-snippets", enabled = false },

  { "nvim-mini/mini.pairs", enabled = false },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        oxlint = {
          args = { "--fix", "$FILENAME" },
          stdin = false,
        },
      },
      -- oxfmt formats everything it supports; the oxc extra adds it for JS, TS, JSON and Vue.
      formatters_by_ft = {
        go = { "goimports" },
        nix = { "nixfmt" },
        typescript = { "oxlint", "oxfmt" },
        javascript = { "oxlint", "oxfmt" },
        css = { "oxfmt" },
        scss = { "oxfmt" },
        less = { "oxfmt" },
        html = { "oxfmt" },
        markdown = { "oxfmt" },
        ["markdown.mdx"] = { "oxfmt" },
        yaml = { "oxfmt" },
        toml = { "oxfmt" },
        graphql = { "oxfmt" },
        handlebars = { "oxfmt" },
      },
    },
  },

  -- gofmt style through goimports, without gofumpt or golangci-lint.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = { settings = { gopls = { gofumpt = false } } },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = { linters_by_ft = { go = {} } },
  },

  -- Detect indentation from the file, like VS Code's editor.detectIndentation.
  { "NMAC427/guess-indent.nvim", lazy = false, opts = {} },

  -- Multiple cursors
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "LazyFile",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      vim.keymap.set({ "n", "x" }, "<C-A-j>", function()
        mc.lineAddCursor(1)
      end, { desc = "Add cursor below" })
      vim.keymap.set({ "n", "x" }, "<C-A-k>", function()
        mc.lineAddCursor(-1)
      end, { desc = "Add cursor above" })
      vim.keymap.set({ "n", "x" }, "<C-n>", function()
        mc.matchAddCursor(1)
      end, { desc = "Add cursor at next match" })
      mc.addKeymapLayer(function(layer)
        layer("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "nix",
        "printf",
        "python",
        "query",
        "regex",
        "rust",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
  },

  {
    "deponian/nvim-base64",
    version = "*",
    config = function()
      require("nvim-base64").setup()
    end,
  },
}
