return {
  {
    "iibe/gruvbox-high-contrast",
    config = function()
      vim.opt.background = "light"
      vim.cmd.colorscheme("gruvbox-high-contrast")
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-high-contrast",
    },
  }
}
