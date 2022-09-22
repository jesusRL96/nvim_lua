local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("editor.lsp.lsp-installer")
require("editor.lsp.handlers").setup()
