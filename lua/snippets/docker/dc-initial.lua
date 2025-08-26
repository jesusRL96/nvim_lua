local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s(
		"docker-compose-boilerplate",
		fmta(
			[[
    version: '<>'

    services:
      <>

    volumes:
      <>

    networks:
      <>
    ]],
			{
				i(1, '3.8'),
				i(2, '# Add your services here'),
				i(3, '# Define named volumes here'),
				i(4, '# Define networks here'),
			}
		)
	),
}
