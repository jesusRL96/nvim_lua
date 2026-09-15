return {
  {
    "L3MON4D3/LuaSnip",
    -- `opts` como función: se ejecuta antes del setup, sin pisar el config por
    -- defecto de lazy ni las opts de LazyVim (history, delete_check_events).
    opts = function(_, opts)
      -- Los snippets de docker también valen en YAML (docker-compose)
      require("luasnip").filetype_extend("yaml", { "docker" })

      -- Snippets propios en formato Lua
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
      })

      return opts
    end,
  },
}
