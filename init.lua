-- Workaround for deprecated functions
if vim.fn.has('nvim-0.10') == 0 then
    vim.tbl_islist = vim.isarray or vim.tbl_islist
end
-- Load all configs
for _, source in ipairs({
	"editor.options",
	"editor.plugins",
	"editor.keymaps",
	"editor.colorscheme",
}) do
	local status_ok, fault = pcall(require, source)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
	end
end
