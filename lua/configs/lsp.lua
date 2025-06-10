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
local servers = {
	ts_ls = {
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = { "typescript", "typescriptreact" },
		root_dir = require("lspconfig.util").root_pattern("tsconfig.json"),
		single_file_support = false,
		init_options = {
			hostInfo = "neovim",
			tsserver = { enable = false }
		}
	},
	emmet_ls = {
		cmd = { "emmet-ls", "--stdio" },
		filetypes = { "html", "typescriptreact" }, -- Only needed filetypes
		single_file_support = false
	},
	pyright = {
		cmd = { get_server_path('pyright-langserver') or 'pyright-langserver', '--stdio' },
		root_dir = util.root_pattern('pyproject.toml', 'setup.py', 'requirements.txt')
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
	vim.g.omitted_servers = {
		'tsserver',
		'emmet_ls',
		'ts_ls',
	}
	local default_configs = require("lspconfig.configs")
	for _, server in ipairs({ "tsserver", "typescript", "ts_ls", "emmet_ls" }) do
		if default_configs[server] then
			default_configs[server] = nil
		end
	end

	for server, config in pairs(servers) do
		require('lspconfig')[server].setup({
			on_attach = M.on_attach,
			capabilities = M.capabilities,
		})
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local clients = vim.lsp.get_clients({ bufnr = args.buf })
		local my_configs = { "ts_ls", "emmet_ls" } -- Your custom configured servers

		local keep_clients = {}

		for _, client in ipairs(clients) do
			if vim.tbl_contains(my_configs, client.name) then
				-- This is one of OUR configured servers
				if not keep_clients[client.name] then
					keep_clients[client.name] = client.id -- Keep first instance
				else
					-- Kill duplicate
					if client.config.root_dir ~= clients[keep_clients[client.name]].config.root_dir then
						client.stop()
					end
				end
			end
		end
	end
})

return M
