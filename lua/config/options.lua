-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LazyVim auto format
vim.g.autoformat = false
vim.g.snacks_animate = false
-- vim.opt.background = "light"
--
-- Markdown
vim.g.mkdp_open_to_the_world = 1
vim.g.mkdp_echo_preview_url = 1
vim.g.mkdp_auto_close = 0
vim.g.mkdp_combine_preview = 1
vim.g.mkdp_combine_preview_auto_refresh = 1
vim.g.mkdp_port = "9190"
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = osc52.paste("+"),
      ["*"] = osc52.paste("*"),
    },
  }
end
