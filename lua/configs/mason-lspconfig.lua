require("mason-lspconfig").setup{
	ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "omnisharp" },
	automatic_installation = false,
}
-- mason_lspconfig = require("mason-lspconfig")
-- local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
-- if not status_ok then
-- 	return
-- end
-- mason_lspconfig.setup()
