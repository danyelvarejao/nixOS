return {
  -- language servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        stylelint_lsp = {
          cmd = { "stylelint-lsp", "--stdio" },
        },
        ts_ls = {
          enabled = true,
          settings = {
            typescript = {
              preferences = {
                autoImportFileExcludePatterns = { "**/dist/**" },
                autoImportSpecifierExcludeRegexes = { ".*dist.*", "dist" },
              },
              exclude = {
                "node_modules",
                "dist",
                "*/dist/*",
                "dist/*",
                "dist/**",
              },
            },
            javascript = {},
            preferences = {
              autoImportFileExcludePatterns = { "**/dist/**" },
              autoImportSpecifierExcludeRegexes = { ".*dist.*" },
            },
            exclude = {
              "node_modules",
              "dist",
              "*/dist/*",
              "dist/*",
              "dist/**",
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
    },
  },
}
