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
