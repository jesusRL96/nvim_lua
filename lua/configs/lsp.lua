-- lua/configs/lsp.lua
local M = {}

M.on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- Diagnostic keymaps
	vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

	-- LSP keymaps
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	vim.keymap.set('n', '<space>f', function()
		vim.lsp.buf.format { async = true }
	end, opts)

	if client.name == 'tsserver' then
		client.server_capabilities.diagnosticProvider = false
		return
	end
	if vim.b[bufnr][client.name] then return end
	vim.b[bufnr][client.name] = true

	if client.name == "omnisharp" then
		-- replaces vim.lsp.buf.definition()
		vim.keymap.set("n", "gd", "<cmd>lua require('omnisharp_extended').lsp_definition()<cr>", opts)
		vim.keymap.set("n", "<C-LeftMouse>", "<cmd>lua require('omnisharp_extended').lsp_definition()<cr>", opts)
		-- replaces vim.lsp.buf.type_definition()
		vim.keymap.set("n", "<leader>D", "<cmd>lua require('omnisharp_extended').lsp_type_definition()<cr>", opts)
		-- replaces vim.lsp.buf.references()
		vim.keymap.set("n", "gr", "<cmd>lua require('omnisharp_extended').lsp_references()<cr>", opts)
		-- replaces vim.lsp.buf.implementation()
		vim.keymap.set("n", "gi", "<cmd>lua require('omnisharp_extended').lsp_implementation()<cr>", opts)
	end

	-- BLOCK DUPLICATE CLIENTS
	local active_clients = vim.lsp.get_active_clients()
	for _, active_client in ipairs(active_clients) do
		if active_client.name == client.name and active_client.id ~= client.id then
			client.stop() -- Kill the duplicate
			return
		end
	end
end

-- Add capabilities
M.capabilities = require('cmp_nvim_lsp').default_capabilities()
M.ts_capabilities = {
	textDocument = {
		synchronization = {
			dynamicRegistration = false,
			willSave = true,
			willSaveWaitUntil = false,
			didSave = true,
		},
	},
}

local function get_server_path(server_name)
	-- Check Mason install first
	local mason_path = vim.fn.stdpath('data') .. '/mason/bin/' .. server_name
	if vim.fn.executable(mason_path) == 1 then
		return mason_path
	end

	-- Check global install
	local global_path = vim.fn.exepath(server_name)
	if global_path ~= '' then
		return global_path
	end

	return nil
end

-- Configure each server
local lspconfig = require('lspconfig')
local util = lspconfig.util
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
local servers = {
	ts_ls = {
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = { "typescript", "typescriptreact" },
		root_dir = require("lspconfig.util").root_pattern("tsconfig.json"),
		single_file_support = false,
		init_options = {
			hostInfo = "neovim",
			tsserver = { enable = false },
			preferences = {
				-- disableSuggestions = true,
				includeCompletionsForModuleExports = false,
				includeCompletionsWithInsertText = false,
			},
			-- Disable workspace symbol search (heavy on memory)
			disableWorkspaceSymbols = true,
		},
		flags = {
			debounce_text_changes = 150,
			allow_incremental_sync = true,
		},
		settings = {
			tsserver = {
				maxTsServerMemory = 2000,
				disableAutomaticTypeAcquisition = true,
				experimental = {
					enableProjectDiagnostics = false,
				},
			},
		}
	},
	emmet_ls = {
		cmd = { "emmet-ls", "--stdio" },
		filetypes = { "html", "typescriptreact" }, -- Only needed filetypes
		single_file_support = false
	},
	pyright = {
		cmd = { get_server_path('pyright-langserver') or 'pyright-langserver', '--stdio' },
		root_dir = util.root_pattern(unpack(python_root_files)),
	},
	omnisharp = {
		cmd = { get_server_path('omnisharp') or 'omnisharp', '--languageserver' },
		root_dir = util.root_pattern('*.sln', '*.csproj')
	},
	rust_analyzer = {
		cmd = { get_server_path('rust-analyzer') or 'rust-analyzer' }
	},
	lua_ls = {
		cmd = { get_server_path('lua-language-server') or 'lua-language-server' },
		settings = {
			Lua = {
				runtime = { version = 'LuaJIT' },
				diagnostics = { globals = { 'vim' } }
			}
		}
	}
}

function M.setup()
	for server, config in pairs(servers) do
		local server_capabilities = server == 'ts_ls' and M.ts_capabilities or M.capabilities

		-- Create the final config by properly merging all layers
		local final_config = vim.tbl_deep_extend('force', {
			on_attach = M.on_attach,
			capabilities = server_capabilities,
		}, config) -- This merges your server-specific config

		require('lspconfig')[server].setup(final_config)
	end
end

return M
