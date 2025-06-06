require('luasnip.loaders.from_vscode').lazy_load() -- Load friendly-snippets
require('luasnip').config.setup({
  history = true,
  update_events = 'TextChanged,TextChangedI',
})
