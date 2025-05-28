function load_config()
	require("configs.mason")
	require("configs.mason-lspconfig")
	require("configs.mason-tool-installer")
end

load_config()
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	-- vim.keymap.set("n", "<space>f", function()
	-- 	vim.lsp.buf.format({ async = true })
	-- end, bufopts)
	if client.name == "ts_ls" then
		client.server_capabilities.document_formatting = false
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
		if string.find(vim.fn.expand('%:p'), 'node_modules') then
      vim.diagnostic.disable(bufnr)
    end
	end
	if client.name == "omnisharp" then
		-- replaces vim.lsp.buf.definition()
		vim.keymap.set("n", "gd", "<cmd>lua require('omnisharp_extended').lsp_definition()<cr>", bufopts)
		vim.keymap.set("n", "<C-LeftMouse>", "<cmd>lua require('omnisharp_extended').lsp_definition()<cr>", bufopts)
		-- replaces vim.lsp.buf.type_definition()
		vim.keymap.set("n", "<leader>D", "<cmd>lua require('omnisharp_extended').lsp_type_definition()<cr>", bufopts)
		-- replaces vim.lsp.buf.references()
		vim.keymap.set("n", "gr", "<cmd>lua require('omnisharp_extended').lsp_references()<cr>", bufopts)
		-- replaces vim.lsp.buf.implementation()
		vim.keymap.set("n", "gi", "<cmd>lua require('omnisharp_extended').lsp_implementation()<cr>", bufopts)
	end
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
	})
end
local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

local lspconfig = require("lspconfig")
local python_root_files = {
	"WORKSPACE",
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"requirements.pip",
	"Pipfile",
	"pyrightconfig.json",
}

require("lspconfig")["pyright"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
	root_dir = lspconfig.util.root_pattern(unpack(python_root_files)),
})
require("lspconfig")["ts_ls"].setup({
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	root_dir = function(fname)
    return require('lspconfig.util').root_pattern(
      'package.json',
      'tsconfig.json',
      'jsconfig.json',
      '.git'
    )(fname) or vim.fn.getcwd()
  end,
	flags = lsp_flags,
	on_attach = on_attach,
})
require("lspconfig")["rust_analyzer"].setup({
	flags = lsp_flags,
	on_attach = on_attach,
	-- Server-specific settings...
	settings = {
		["rust-analyzer"] = {},
	},
})
local configs = require("lspconfig/configs")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("lspconfig")["emmet_ls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = {
		"html",
		"typescriptreact",
		"javascriptreact",
		"javascript",
		"css",
		"sass",
		"scss",
		"less",
		"django",
		"jinja.html",
		"htmldjango",
	},
	init_options = {
		-- js = {
		-- 	options= {
		-- 		["jsx.enabled"] = true,
		-- 		['markup.attributes']= {
		-- 				['class']= 'className',
		-- 				['class*']= 'styleName',
		-- 				['for']= 'htmlFor'
		-- 		},
		-- 		['markup.valuePrefix']= {
		-- 				['class*']= 'styles'
		-- 		}
		-- 	}
		-- },
		html = {
			options = {
				-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
				["bem.enabled"] = true,
			},
		},
	},
})

require("lspconfig").omnisharp.setup({
	-- cmd = { "dotnet", "/path/to/omnisharp/OmniSharp.dll" },
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = {
		["textDocument/definition"] = require("omnisharp_extended").definition_handler,
		["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
		["textDocument/references"] = require("omnisharp_extended").references_handler,
		["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
	},
})
