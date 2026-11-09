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
      formatters_by_ft = {
        nix = { "nixfmt" },
        scss = { "oxfmt" },
        typescript = { "oxlint", "oxfmt" },
        javascript = { "oxlint", "oxfmt" },
        markdown = { "oxfmt" },
        ["markdown.mdx"] = { "oxfmt" },
      },
    },
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
