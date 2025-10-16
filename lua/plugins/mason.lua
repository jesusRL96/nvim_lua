return {{
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      "pyright",
      "black",
      "debugpy",
      "ruff",
      "lua-language-server",
      "stylua",
      "typescript-language-server",
      "prettier",
      "bash-language-server",
      "json-lsp",
      "yaml-language-server",
    },
  },
}}
