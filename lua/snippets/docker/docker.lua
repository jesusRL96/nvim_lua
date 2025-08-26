local ls = require("luasnip")
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta
local i = ls.insert_node
local t = ls.text_node

return {
	s(
		"redis-service",
		fmta(
			[[
  redis:
    image: redis:<>
    ports:
      - "<>:6379"
    networks:
      - <>
    ]],
			{
				i(1, "alpine"),
				i(2, "6379"),
				i(3, "backend"),
			}
		)
	),

	s(
		"dj-cmd-production",
		fmta(
			[[
    command: gunicorn --workers <> --limit-request-fields 32768 --limit-request-field_size 0 --limit-request-line 0 --timeout <> -b :<> <> -k uvicorn.workers.UvicornWorker
    ]],
			{
				i(1, "6"),
				i(2, "3600"),
				i(3, "8000"),
				i(4, "app.asgi:application"),
			}
		)
	),

	s(
		"docker-host",
		fmta(
			[[
    extra_hosts:
      - "host.docker.internal:host-gateway"
    ]],
			{}
		)
	),
}
