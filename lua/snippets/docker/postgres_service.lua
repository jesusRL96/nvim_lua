local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s(
		"postgres-service",
		fmta(
			[[
    <>:
      image: postgres:<>
      volumes:
        - <>:/var/lib/postgresql/data
      env_file:
        - ./<>
      environment:
        - POSTGRES_DB=${<>}
        - POSTGRES_USER=${<>}
        - POSTGRES_PASSWORD=${<>}
      networks:
        - <>
    ]],
			{
				i(1, "db"),
				i(2, "17"),
				i(3, "./data/db"),
				i(4, ".env"),
				i(5, "DB_NAME"),
				i(6, "DB_USER"),
				i(7, "DB_PASSWORD"),
				i(8, "backend"),
			}
		)
	),
}
