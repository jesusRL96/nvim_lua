o = vim.opt

o.ignorecase = true
o.autoindent = true
o.number = true
o.relativenumber = true
o.showmatch = true
o.hlsearch = true
o.wildmode = {"longest","list"}
o.mouse = "a"
vim.cmd "filetype plugin indent on"
o.tabstop = 2       
o.expandtab = false     
o.shiftwidth = 2  
o.softtabstop = 2
--[[ o.cursorcolumn = true ]]
o.cursorline = true
--[[ o.scrolloff = 999 ]]

o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 20
o.foldlevelstart = -1
