local configs = require("nvim-treesitter.configs")
configs.setup({
	ensure_installed = {
		"c", "lua", "vim", "vimdoc", "query",
		"javascript", "html", "htmldjango",
		"css", "scss", "csv",
		"python", "sql", "yaml", "xml", "matlab", "typescript",
		"ninja", "markdown", "json", "http", "gitignore", "gitcommit", "dockerfile", "bash"

	},
	sync_install = false,
	auto_install = true,
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true, disable = { "yaml" } },
	-- context_commentstring = {
	-- 	enable = true,
	-- 	enable_autocmd = false,
	-- },
	autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
    filetypes = {
			'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
			'xml',
			'php',
			'markdown',
			'astro', 'glimmer', 'handlebars', 'hbs'
		},
  }
})
