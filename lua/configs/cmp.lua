local cmp = require('cmp')
local lspkind = require('lspkind')

-- Safe require for LuaSnip (after ensuring it's initialized)
local luasnip_ok, luasnip = pcall(require, "luasnip")

-- Optimized source priority and filtering
local sources = {
	-- Primary LSP source (highest priority)
	{ name = 'nvim_lsp', priority = 1000 },

	-- Snippet engine - use only ONE
	luasnip_ok and { name = 'luasnip', priority = 900 } or { name = 'vsnip', priority = 900 },

	-- Secondary sources
	{ name = 'path',     priority = 500 },
	{ name = 'buffer',   priority = 250 },
}

-- Filter out nil sources
local filtered_sources = {}
for _, source in ipairs(sources) do
	if source then table.insert(filtered_sources, source) end
end

-- Enhanced formatting
local formatting = {
	fields = { 'kind', 'abbr', 'menu' },
	format = function(entry, vim_item)
		-- Truncate long items
		local max_width = 50
		if #vim_item.abbr > max_width then
			vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 3) .. '...'
		end

		-- Show source name
		vim_item.menu = '[' .. entry.source.name .. ']'

		-- Add lspkind icons
		vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = 'symbol' })

		return vim_item
	end
}

cmp.setup({
	snippet = {
		expand = function(args)
			-- Use only ONE snippet engine
			if luasnip_ok then
				luasnip.lsp_expand(args.body)        -- Use LuaSnip if available
			else
				vim.fn['vsnip#anonymous'](args.body) -- Fallback to Vsnip
			end
		end,
	},

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),

		-- Enhanced Tab handling
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true })
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<S-Tab>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),

		-- Keep existing mappings
		['<CR>'] = cmp.mapping.confirm({ select = false }),
	}),

	sources = cmp.config.sources(filtered_sources),

	formatting = formatting,

	experimental = {
		ghost_text = true,
		native_menu = false,
	},

	performance = {
		debounce = 30,
		throttle = 15,
		fetching_timeout = 50,
	}
})

-- Filetype-specific configurations (unchanged)
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources(
		{ { name = 'git' } },
		{ { name = 'buffer' } }
	)
})

-- Command-line configurations (unchanged)
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources(
		{ { name = 'path' } },
		{ { name = 'cmdline' } }
	)
})

cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = 'buffer' } }
})

