local null_ls = require('null-ls')

  
--mason_null_ls.setup_handlers = {
--    function(source_name)
--      -- all sources with no handler get passed here
--    end,
--    stylua = function()
--      null_ls.register(null_ls.builtins.formatting.prettier)
--    end,
--    stylua = function()
--      null_ls.register(null_ls.builtins.formatting.stylua)
--    end,
--}

-- will setup any installed and configured sources above
--null_ls.setup()
require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.prettier, -- markdown formatting
    require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.diagnostics.eslint,
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.formatting()<CR>")

      -- format on save
      vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
    end

    if client.server_capabilities.documentRangeFormattingProvider then
      vim.cmd("xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.range_formatting({})<CR>")
    end
  end,
})
