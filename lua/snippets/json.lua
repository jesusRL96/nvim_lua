local ls = require("luasnip")
return {
  ls.parser.parse_snippet({
    trig = "test",
    wordTrig = true,
  }, [[{
  "venvPath": "${1:.}",
  "venv": "${2:venv}",
  "include": ["${3:.}"],
  "extraPaths": ["${4:src}"]
}]])
}
