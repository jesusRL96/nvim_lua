vim.cmd([[
try
  colorscheme carbonfox
  " set background=light
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])
