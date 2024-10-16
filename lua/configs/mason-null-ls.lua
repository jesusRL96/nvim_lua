local null_ls = require("null-ls")
local mason_null_ls = require("mason-null-ls")
null_ls.setup()

mason_null_ls.setup({
	ensure_installed = {
		"stylua",
		"jq",
		"black",
		"emmet-ls",
		"prettier",
		"prettierd",
		"xmlformatter",
		"djlint",
		"eslint-lsp",
		"omnisharp",
		"omnisharp-mono",
	},
	handlers = {
		function() end, -- disables automatic setup of all null-ls sources
		stylua = function(source_name, methods)
			null_ls.register(null_ls.builtins.formatting.stylua)
		end,
		shfmt = function(source_name, methods)
			-- custom logic
			mason_null_ls.default_setup(source_name, methods) -- to maintain default behavior
		end,
	},
})

setup_handlers = {
   function(source_name)
     -- all sources with no handler get passed here
   end,
   prettier = function()
     null_ls.register(null_ls.builtins.formatting.prettier)
   end,
   stylua = function()
     null_ls.register(null_ls.builtins.formatting.stylua)
   end,
}

