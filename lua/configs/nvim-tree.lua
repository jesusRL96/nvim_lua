require('nvim-tree').setup({
  view = {
    width = 30,
    side = 'left',
  },
  filters = {
    dotfiles = false,
  },
  git = {
    ignore = false,
  },
})
