require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt", "spectre_panel" },
  disable_in_macro = true,
  enable_afterquote = false,
  map_cr = true,  -- Map <CR> to confirm completion
})
