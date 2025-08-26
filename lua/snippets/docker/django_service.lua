local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

return {
  s(
    "django-service",
    fmta(
      [[
      <>:
        build: <>
        command: python manage.py runserver 0.0.0.0:8000
        volumes:
          - <>:<>
        ports:
          - "<>:8000"
        env_file:
          - ./<>
        depends_on:
          - <>
        networks:
          - <>
      ]],
      {
        i(1, "web"),
        i(2, "./app"),
        rep(2),
        i(3, "/app"),
        i(4, "8000"),
        i(5, ".env"),
        i(6, "db"),
        i(7, "backend"),
      }
    )
  ),
}
