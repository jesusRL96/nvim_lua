-- Automatically install packer
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()
local fn = vim.fn

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of pluginsuse
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("configs.autopairs")
		end,
	}) -- Autopairs, integrates with both cmp and treesitter
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("configs.comment")
		end,
	}) -- Easily comment stuff
	use("kyazdani42/nvim-web-devicons")
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("configs.nvim-tree")
		end,
	})
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
	-- use({
	-- 	"akinsho/bufferline.nvim",
	-- 	config = function()
	-- 		require("configs.bufferline")
	-- 	end,
	-- 	requires = 'nvim-tree/nvim-web-devicons'
	-- })
	use({
		"willothy/nvim-cokeline",
		config = function()
			require("configs.cokeline")
		end,
		requires = "nvim-tree/nvim-web-devicons",
	})
	use("moll/vim-bbye")
	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("configs.lualine")
		end,
	})
	use({
		"akinsho/toggleterm.nvim",
		config = function()
			require("configs.toggleterm")
		end,
	})

	-- colorschemes
	use({ "EdenEast/nightfox.nvim" })
	use("savq/melange")

	-- snippets
	use({ "L3MON4D3/LuaSnip" }) --snippet engine
	use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to use
	use({ "onsails/lspkind.nvim" })

	-- cmp plugins
	use({ "hrsh7th/nvim-cmp", after = "lspkind.nvim" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" }) -- buffer completions
	use({ "hrsh7th/cmp-path", after = "cmp-buffer" }) -- path completions
	use({ "hrsh7th/cmp-cmdline", after = "cmp-path" }) -- cmdline completions
	use({ "hrsh7th/cmp-vsnip" })
	use({ "hrsh7th/vim-vsnip" })
	use({ "hrsh7th/vim-vsnip-integ" })
	use({ "saadparwaiz1/cmp_luasnip", after = "cmp-cmdline" }) -- snippet completions
	use({
		"hrsh7th/cmp-nvim-lsp",
		after = "cmp_luasnip",
		config = function()
			require("configs.cmp")
		end,
	})

	-- Telescope
	use({ "nvim-telescope/telescope.nvim" })
	use({
		"nvim-telescope/telescope-media-files.nvim",
		after = "telescope.nvim",
		config = function()
			require("configs.telescope")
		end,
	})

	-- LSP
	use({ "Hoffs/omnisharp-extended-lsp.nvim" })
	use({
		"williamboman/mason.nvim",
		after = "omnisharp-extended-lsp.nvim",
	})
	use({ "WhoIsSethDaniel/mason-tool-installer.nvim", after = "mason.nvim" })

	use({
		"stevearc/conform.nvim",
		config = function()
			require("configs.conform")
		end,
	})
	use({ "neovim/nvim-lspconfig" }) -- enable LSP
	use({
		"williamboman/mason-lspconfig.nvim",
		after = { "mason.nvim" },
		config = function()
			require("configs.lsp")
		end,
	})
	use({
		"MunifTanjim/prettier.nvim",
		config = function()
			require("configs.prettier")
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})
	-- use "nvim-treesitter/playground"
	use({ "p00f/nvim-ts-rainbow", after = "nvim-treesitter" })
	use({
		"JoosepAlviste/nvim-ts-context-commentstring",
		after = "nvim-treesitter",
		config = function()
			require("configs.treesitter")
		end,
	})
	use({
		"windwp/nvim-ts-autotag",
		after = "nvim-treesitter",
	})

	-- Git
	use("tpope/vim-fugitive")
	use({
		"lewis6991/gitsigns.nvim",
		after = "vim-fugitive",
		config = function()
			require("configs.gitsigns")
		end,
	})
	use({
		"airblade/vim-gitgutter",
		after = "vim-fugitive",
	})
	use({
		"kdheepak/lazygit.nvim",
		requires = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").load_extension("lazygit")
		end,
	})
	-- session
	use({
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		module = "persistence",
		config = function()
			require("persistence").setup()
		end,
	})

	-- editorconfig
	use({ "gpanders/editorconfig.nvim" })

	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
