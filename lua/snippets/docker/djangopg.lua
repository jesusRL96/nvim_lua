local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
  s({
    trig = "djangopg",
    dscr = "Docker Compose for Django and PostgreSQL",
  }, {
    t({
      "version: '3.8'",
      "",
      "services:",
      "  db:",
      "    image: postgres:17",
      "    volumes:",
      "      - ./data/db:/var/lib/postgresql/data",
      "    env_file:",
      "      - ./.env",
      "    environment:",
      "      - POSTGRES_DB=${DB_NAME}",
      "      - POSTGRES_USER=${DB_USER}",
      "      - POSTGRES_PASSWORD=${DB_PASSWORD}",
      "    networks:",
      "      - backend",
      "",
      "  web:",
      "    build: ./app",
      "    command: python manage.py runserver 0.0.0.0:8000",
      "    volumes:",
      "      - ./app:/app",
      "    ports:",
      "      - \"8000:8000\"",
      "    env_file:",
      "      - ./.env",
      "    environment:",
      "      - DB_HOST=db",
      "      - DB_NAME=${DB_NAME}",
      "      - DB_USER=${DB_USER}",
      "      - DB_PASSWORD=${DB_PASSWORD}",
      "    depends_on:",
      "      - db",
      "    networks:",
      "      - backend",
      "",
      "networks:",
      "  backend:",
      "  frontend:",
    }),
  }),
}

