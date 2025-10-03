vim.cmd([[
try
  colorscheme gruvbox-high-contrast
  set background=dark
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])
