local ls = require("luasnip")
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta
local i = ls.insert_node
local t = ls.text_node

return {
	s(
		"dj-set-postgres_db",
		fmta(
			[[
    DATABASES = {
      "default": {
        "ENGINE": "<>",
        "NAME": os.environ.get("DB_NAME"),
        "USER": os.environ.get("DB_USER"),
        "PASSWORD": os.environ.get("DB_PASSWORD"),
        "HOST": os.environ.get("DB_HOST"),
        "PORT": os.environ.get("DB_PORT"),
      }
    }
    ]],
			{
				i(1, "django.db.backends.postgresql"),
			}
		)
	),

	s(
		"dj-set-static",
		t(
			[[
    STATIC_ROOT = "static"
    ]]
		)
	),

	s(
		"dj-set-channels_layers",
		fmta(
			[[
    CHANNEL_LAYERS = {
      "default": {
        "BACKEND": "<>",
        "CONFIG": {
          "url": os.environ.get("REDIS_URL", "redis://localhost:6379/0"),
        },
      },
    }
    ]],
			{
				i(1, "channels_redis.core.RedisChannelLayer"),
			}
		)
	),
}
