return {
  {
    "LazyVim/LazyVim",
    opts = {
      clipboard = {
        ---@type string|fun():string
        name = "xclip-primary",
        ---@type table<string, string[]>
        copy = {
          ["+"] = { "xclip", "-selection", "primary" },
          ["*"] = { "xclip", "-selection", "primary" },
        },
        ---@type table<string, string[]>
        paste = {
          ["+"] = { "xclip", "-selection", "primary", "-o" },
          ["*"] = { "xclip", "-selection", "primary", "-o" },
        },
        cache_enabled = true,
      },
    },
  },
}
