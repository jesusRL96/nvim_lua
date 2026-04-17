return {
  {
    "L3MON4D3/LuaSnip",
    opts = {
      -- any options you want to override
    },
    config = function(_, opts)
      -- First apply LazyVim's default config
      require("luasnip").config.set_config(opts)
      -- Docker configurations
      require("luasnip").filetype_extend("yaml", { "docker" })
      -- Then add your custom snippets
      local snippets_path = vim.fn.stdpath("config") .. "/lua/snippets"
      require("luasnip.loaders.from_lua").lazy_load({
        paths = snippets_path
      })

    end,
  },
}
