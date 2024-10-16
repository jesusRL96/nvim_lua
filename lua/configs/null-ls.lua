local null_ls = require("null-ls")

-- will setup any installed and configured sources above
--null_ls.setup()
require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.prettier,
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.djlint,
		-- require("null-ls").builtins.formatting.djhtml,
		-- require("null-ls").builtins.diagnostics.eslint,
		require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
	},
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.format{async = true}<CR>")

			-- format on save
			--[[ vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()") ]]
		end

		if client.server_capabilities.documentRangeFormattingProvider then
			vim.cmd("xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.format{async = true}<CR>")
		end
	end,
})
