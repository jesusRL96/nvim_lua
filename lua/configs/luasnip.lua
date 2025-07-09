-- luasnip.lua
local ls = require("luasnip")

-- Basic configuration
ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Add pyright snippet directly
ls.add_snippets("json", {
  ls.parser.parse_snippet({
    trig = "pyright",
    wordTrig = true,
  }, [[{
  "venvPath": ".",
  "venv": "venv",
	"include":["."],
  "extraPaths": ["src"]
}]])
})

