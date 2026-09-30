return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true, -- muestra dotfiles (.env, .gitignore, ...)
          ignored = true, -- muestra también lo ignorado por git
        },
        files = { hidden = true },
        grep = { hidden = true },
      },
    },
  },
}
