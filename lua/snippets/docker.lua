-- In docker.lua
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local rep = ls.function_node(function(args)
  return args[1][1]
end)

return {
  s("djangopg", {
    t({
      "version: '3.8'",
      "",
      "services:",
      "  db:",
      "    image: postgres:15",
      "    volumes:",
      "      - postgres_data:/var/lib/postgresql/data/",
      "    environment:",
      "      POSTGRES_DB: ",
    }),
    i(1, "mydb"),
    t({
      "",
      "      POSTGRES_USER: ",
    }),
    i(2, "myuser"),
    t({
      "",
      "      POSTGRES_PASSWORD: ",
    }),
    i(3, "mypassword"),
    t({
      "",
      "    healthcheck:",
      '      test: ["CMD-SHELL", "pg_isready -U ',
    }),
    rep(2),
    t({
      '"]',
      "      interval: 5s",
      "      timeout: 5s",
      "      retries: 5",
      "",
      "  web:",
      "    build: .",
      "    command: python manage.py runserver 0.0.0.0:8000",
      "    volumes:",
      "      - .:/app",
      "    ports:",
      '      - "',
    }),
    i(4, "8000:8000"),
    t({
      '"',
      "    environment:",
      "      DB_HOST: db",
      "      DB_NAME: ",
    }),
    rep(1),
    t({
      "",
      "      DB_USER: ",
    }),
    rep(2),
    t({
      "",
      "      DB_PASSWORD: ",
    }),
    rep(3),
    t({
      "",
      "    depends_on:",
      "      db:",
      "        condition: service_healthy",
      "",
      "volumes:",
      "  postgres_data:",
    }),
  }),
}
