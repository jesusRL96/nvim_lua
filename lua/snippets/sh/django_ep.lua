local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
  s({
    trig = "entrypoint-django",
    dscr = "Minimal Django entrypoint script",
  }, {
    t({
      "#!/bin/sh",
      "",
      "python manage.py migrate",
      "python manage.py collectstatic --no-input",
      "",
      "exec \"$@\"",
    }),
  }),
}

