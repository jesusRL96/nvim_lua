require('Comment').setup({
	padding = true, -- Add space after comment marker
	sticky = true,  -- Keep cursor position when commenting
	mappings = {
		basic = true, -- Enable basic mappings (gcc, gbc)
		extra = true, -- Enable extra mappings (gco, gcO)
	}
})
