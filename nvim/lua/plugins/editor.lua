return {
  -- yank ring
  {
    "gbprod/yanky.nvim",
    opts = { highlight = { timer = 150 } },
    event = "LazyFile",
  },

  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          enabled = false,
          label = { exclude = "rdc" },
        },
        treesitter = {
          label = { before = false, after = false },
        },
      },
    },
  },

  { "folke/todo-comments.nvim", enabled = false },

  -- <leader>q, <leader>w and <leader><tab> are VS Code style mappings, see config/keymaps.lua.
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local replaced = { ["<leader>q"] = true, ["<leader>w"] = true, ["<leader><tab>"] = true }
      for _, group in ipairs(opts.spec or {}) do
        for i = #group, 1, -1 do
          if type(group[i]) == "table" and replaced[group[i][1]] then
            table.remove(group, i)
          end
        end
      end
    end,
  },
  {
    "folke/persistence.nvim",
    keys = {
      { "<leader>qs", false },
      { "<leader>qS", false },
      { "<leader>ql", false },
      { "<leader>qd", false },
    },
  },

  {
    "folke/trouble.nvim",
    opts = {
      auto_close = true, -- auto close when there are no items
      auto_refresh = true, -- auto refresh when open
      modes = {
        cascade = {
          mode = "diagnostics", -- inherit from diagnostics mode
          auto_open = false, -- auto open when there are items
          filter = function(items)
            local severity = vim.diagnostic.severity.HINT
            for _, item in ipairs(items) do
              severity = math.min(severity, item.severity)
            end
            return vim.tbl_filter(function(item)
              return item.severity == severity
            end, items)
          end,
        },
      },
    },
  },

  { "gabrielpoca/replacer.nvim", lazy = true },

  {
    "axkirillov/hbac.nvim",
    opts = {
      autoclose = false, -- set autoclose to false if you want to close buffers manually
      autopin = true, -- set autopin to false if you want to pin buffers manually
      autopin_events = { "InsertEnter", "BufModifiedSet" }, -- The vim events on which autopin will trigger
      threshold = 10, -- hbac will start closing unedited buffers once that number is reached
      count_pinned = true, -- whether pinned buffers will count towards the autoclose threshold
    },
  },
}
