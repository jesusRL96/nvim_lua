local cmp = require('cmp')
local lspkind = require('lspkind')

-- Optimized source priority and filtering
local sources = {
	-- Primary LSP source (highest priority)
	{ name = 'nvim_lsp', priority = 1000 },

	-- Snippet engines (choose one)
	{ name = 'vsnip',    priority = 800 }, -- vsnip
	-- { name = 'luasnip', priority = 800 }, -- luasnip

	-- Secondary sources
	{ name = 'path',     priority = 500 },
	{ name = 'buffer',   priority = 250 },
	-- { name = 'cmp_tabnine', priority = 750 },
}

-- Enhanced formatting with better client detection
local formatting = {
	fields = { 'kind', 'abbr', 'menu' },
	format = function(entry, vim_item)
		-- Truncate long items
		local max_width = 50
		if #vim_item.abbr > max_width then
			vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 3) .. '...'
		end

		-- Show LSP client name if available
		if entry.source.name == 'nvim_lsp' then
			local client_name = entry.source.source.client and entry.source.source.client.name or 'LSP'
			vim_item.menu = '[' .. client_name .. ']'
		else
			vim_item.menu = '[' .. entry.source.name .. ']'
		end

		-- Add lspkind icons
		vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = 'symbol' })

		-- Special handling for TabNine if used
		if entry.source.name == 'cmp_tabnine' then
			vim_item.kind = ''
			local detail = (entry.completion_item.data or {}).detail
			if detail and detail:find('.*%%.*') then
				vim_item.kind = vim_item.kind .. ' ' .. detail
			end
		end

		return vim_item
	end
}

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn['vsnip#anonymous'](args.body) -- vsnip
			-- require('luasnip').lsp_expand(args.body) -- luasnip
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
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
	}),

	sources = cmp.config.sources(sources),

	formatting = formatting,

	experimental = {
		ghost_text = true,
		native_menu = false,
	},

	-- Performance optimizations
	performance = {
		debounce = 30,
		throttle = 15,
		fetching_timeout = 50,
	}
})

-- Filetype-specific configurations
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources(
		{ { name = 'git' } },
		{ { name = 'buffer' } }
	)
})

-- Command-line configurations
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
