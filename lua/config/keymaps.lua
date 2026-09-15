-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

local opts = { noremap = true, silent = true }

-- Normal --
-- Navegación entre ventanas
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Copiar y pegar contra el portapapeles del sistema
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank in system clipboard register" })
map({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard register" })

-- Insert --
-- jk rápido para salir de modo inserción
map("i", "jk", "<ESC>", opts)

-- Visual --
-- Mantener la selección al indentar
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Git
-- Antes era <leader>gdvs, que dejaba colgado el <leader>gd de LazyVim ("Git Diff")
map("n", "<leader>gv", "<cmd>Gvdiffsplit!<cr>", { desc = "Git Vertical Diff Split" })

-- Ir al último punto de inserción (el autocmd que lo registra está en config/autocmds.lua)
map("n", "go", function()
  if vim.g.last_insert_buf and vim.api.nvim_buf_is_loaded(vim.g.last_insert_buf) then
    vim.api.nvim_set_current_buf(vim.g.last_insert_buf)
    pcall(vim.api.nvim_win_set_cursor, 0, vim.g.last_insert_pos)
  else
    vim.notify("No last insert position recorded", vim.log.levels.WARN)
  end
end, { desc = "Go to last insert (across buffers)" })

map("n", "gi", "`.", { desc = "Go to last insert position (normal mode)" })

-- Mover el buffer actual en la bufferline.
-- Antes <M-h>/<M-l>; <M-l> chocaba con el accept de sugerencia de Avante.
map("n", "<M-,>", function()
  require("bufferline").move(-1)
end, { desc = "Move buffer left" })

map("n", "<M-.>", function()
  require("bufferline").move(1)
end, { desc = "Move buffer right" })
