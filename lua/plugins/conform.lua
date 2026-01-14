return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      sql_formatter = {
        args = {
          "--language",
          "postgresql",
        },
      },
      djlint = {
        command = "djlint",
        args = {
          "--reformat",
          "-", -- stdin
        },
        stdin = true,
      },
    },
    formatters_by_ft = {
      sql = { "sql_formatter" },
      htmldjango = { "djlint" },
    },
  },
}
