-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

local opts = { noremap = true, silent = true }

-- Normal --
-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Copy & Paste
map({"n", "x"}, "<leader>y", '"+y', {desc = "Yank in system clipboard register"})
map({"n", "x"}, "<leader>p", '"+p', {desc = "Paste from system clipboard register"})

-- Insert --
-- Press jk fast to exit insert mode
map("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Git
map("n", "gdvs", "<cmd>:Gvdiffsplit!<cr>", opts)


-- Global last insert
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.g.last_insert_buf = vim.api.nvim_get_current_buf()
    vim.g.last_insert_pos = vim.api.nvim_win_get_cursor(0)
  end,
})

vim.keymap.set("n", "go", function()
  if vim.g.last_insert_buf and vim.api.nvim_buf_is_loaded(vim.g.last_insert_buf) then
    vim.api.nvim_set_current_buf(vim.g.last_insert_buf)
    pcall(vim.api.nvim_win_set_cursor, 0, vim.g.last_insert_pos)
  else
    vim.notify("No last insert position recorded", vim.log.levels.WARN)
  end
end, { desc = "Go to last insert (across buffers)" })

vim.keymap.set("n", "gi", "`.", { desc = "Go to last insert position (normal mode)" })

-- Move tab left with Alt+h
vim.keymap.set("n", "<M-h>", function()
  require("bufferline").move(-1)
end, { desc = "Move tab left" })

-- Move tab right with Alt+l
vim.keymap.set("n", "<M-l>", function()
  require("bufferline").move(1)
end, { desc = "Move tab right" })
