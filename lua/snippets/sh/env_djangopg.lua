local ls = require("luasnip")
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta
local i = ls.insert_node

return {
	s(
		"django-env",
		fmta(
			[[
    # PostgreSQL Database Settings
    DB_NAME=<>
    DB_USER=<>
    DB_PASSWORD=<>
    DB_HOST=<>
    DB_PORT=<>

    # Django Settings
    DJANGO_SETTINGS_MODULE=<>
    DJANGO_DEBUG=<>
    DJANGO_SECRET_KEY=<>
    DJANGO_ALLOWED_HOSTS=<>

    # Optional: Email Settings
    EMAIL_BACKEND=<>
    DEFAULT_FROM_EMAIL=<>

    # Optional: Cache Settings
    REDIS_URL=<>
    ]],
			{
				i(1, "mydb"),
				i(2, "myuser"),
				i(3, "mypassword"),
				i(4, "db"),
				i(5, "5432"),
				i(6, "app.settings"),
				i(7, "True"),
				i(8, "your-secret-key-here"),
				i(9, "localhost,127.0.0.1,0.0.0.0"),
				i(10, "django.core.mail.backends.console.EmailBackend"),
				i(11, "example@email"),
				i(12, "redis://redis:6379/0"),
			}
		)
	),
}
