o = vim.opt

-- vim.g.loaded_node_provider = 0

o.ignorecase = true
o.autoindent = true
o.number = true
o.relativenumber = true
o.showmatch = true
o.hlsearch = true
o.wildmode = { "longest", "list" }
o.mouse = "a"
vim.cmd("filetype plugin indent on")
o.tabstop = 2
o.expandtab = false
o.shiftwidth = 2
o.softtabstop = 2
--[[ o.cursorcolumn = true ]]
o.cursorline = true
--[[ o.scro/home/jesus/.local/state/nvim/swap//%home%jesus%.config%nvim%lua%editor%opt
ions.lua.swplloff = 999 ]]

o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 20
o.foldlevelstart = -1
o.listchars = {
	tab = "→ ",
	extends = "⟩",
	precedes = "⟨",
	space = "·",
	eol = "↲",
}
-- o.list = true
-- o.synmaxcol = 100
o.ttyfast = true

vim.g.clipboard = {
	name = 'OSC 52',
	copy = {
		['+'] = require('vim.ui.clipboard.osc52').copy('+'),
		['*'] = require('vim.ui.clipboard.osc52').copy('*'),
	},
	paste = {
		['+'] = require('vim.ui.clipboard.osc52').paste('+'),
		['*'] = require('vim.ui.clipboard.osc52').paste('*'),
	},
}

-- Wrap
o.wrap = false
o.linebreak = true
o.scrolloff = 3

o.textwidth = 0
o.wrapmargin = 0

o.history = 1000
o.lazyredraw = true
o.synmaxcol = 200
o.timeoutlen = 500
o.undolevels=100
o.maxmempattern=2000000

o.cursorline = false
o.cursorcolumn = false
o.foldmethod = 'manual'



-- deshabilitar node_modules
vim.api.nvim_create_autocmd('BufReadPre', {
  pattern = '*/node_modules/*',
  callback = function()
    -- Disable LSP for files inside `node_modules`
    vim.diagnostic.disable()
    vim.defer_fn(function()
      vim.cmd('TSBufDisable highlight') -- Disable Treesitter (if used)
    end, 0)
  end,
})
