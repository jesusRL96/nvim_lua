local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "env-djangopg",
		dscr = ".env file for Django with Postgres configuration",
	}, {
		t({ "# PostgreSQL Database Settings", "POSTGRES_DB=" }),
		i(1, "mydb"),
		t({ "", "POSTGRES_USER=" }),
		i(2, "myuser"),
		t({ "", "POSTGRES_PASSWORD=" }),
		i(3, "mypassword"),
		t({ "", "POSTGRES_HOST=db", "POSTGRES_PORT=5432", "", "# Django Database Connection", "DB_NAME=${POSTGRES_DB}",
			"DB_USER=${POSTGRES_USER}", "DB_PASSWORD=${POSTGRES_PASSWORD}", "DB_HOST=${POSTGRES_HOST}",
			"DB_PORT=${POSTGRES_PORT}", "", "# Django Settings", "DJANGO_SETTINGS_MODULE=project.settings.dev",
			"DJANGO_DEBUG=True", "DJANGO_SECRET_KEY=" }),
		i(4, "your-secret-key-here"),
		t({ "", "DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0", "", "# Optional: Email Settings",
			"EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend", "DEFAULT_FROM_EMAIL=webmaster@localhost", "",
			"# Optional: Cache Settings", "REDIS_URL=redis://redis:6379/0", "" }),
	}),
}
