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
})
