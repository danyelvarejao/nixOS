-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- These mirror my VS Code (VSCodeVim) settings and keybindings.

local map = vim.keymap.set

-- LazyVim groups replaced by the VS Code style <leader>w, <leader>q and <leader><tab>.
for _, lhs in ipairs({
  "<leader>qq",
  "<leader>wd",
  "<leader>wm",
  "<leader><tab>l",
  "<leader><tab>o",
  "<leader><tab>f",
  "<leader><tab><tab>",
  "<leader><tab>]",
  "<leader><tab>d",
  "<leader><tab>[",
}) do
  pcall(vim.keymap.del, "n", lhs)
end

-- Faster movement to the start and end of the line
map({ "n", "x" }, "H", "^", { desc = "Start of line" })
map({ "n", "x" }, "L", "g_", { desc = "End of line" })

-- * stays on the current match
map("n", "*", "*N", { desc = "Search word under cursor" })

-- Keep the cursor centered
map("n", "n", "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zzzv'", { expr = true, desc = "Prev search result" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

-- { and } swapped for ortholinear keyboards
map({ "n", "x" }, "{", "}")
map({ "n", "x" }, "}", "{")

-- Increment and decrement
map({ "n", "x" }, "+", "<C-a>", { desc = "Increment" })
map({ "n", "x" }, "-", "<C-x>", { desc = "Decrement" })

-- Indent and outdent with a single press
map("n", ">", ">>", { desc = "Indent line" })
map("n", "<", "<<", { desc = "Outdent line" })

map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "<leader>nl", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Buffers as editor tabs
map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<leader><Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
map("n", "<leader>q", function()
  Snacks.bufdelete()
end, { desc = "Close buffer" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })

-- Pickers
map("n", "<leader>o", function()
  Snacks.picker.commands()
end, { desc = "Commands" })
map("n", "<leader>p", LazyVim.pick("files"), { desc = "Find files" })
map("n", "<C-p>", LazyVim.pick("files"), { desc = "Find files" })
map("n", "<C-r>", function()
  Snacks.picker.projects()
end, { desc = "Recent projects" })

-- Explorer
map("n", "<C-e>", function()
  Snacks.explorer({ cwd = LazyVim.root() })
end, { desc = "Explorer" })

-- Terminal
map("n", "<C-t>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal" })
map("t", "<C-t>", "<cmd>close<cr>", { desc = "Hide terminal" })

-- Code
map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>r", function()
  return ":" .. require("inc_rename").config.cmd_name .. " " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename symbol" })
map("n", "gn", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "gp", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })

-- Duplicate the selected lines below
map("x", "<leader>d", ":t'><cr>", { silent = true, desc = "Duplicate selection" })
