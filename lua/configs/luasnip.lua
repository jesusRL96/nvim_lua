-- luasnip.lua
local ls = require("luasnip")

-- Docker configurations
require("luasnip").filetype_extend("yaml", { "docker" })

-- Basic configuration
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
})

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Load custom snippet files
require("luasnip.loaders.from_lua").lazy_load({
	paths = {
		vim.fn.stdpath("config") .. "/lua/snippets",
	}
})
