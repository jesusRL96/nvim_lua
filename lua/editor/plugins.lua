-- Packer bootstrap and setup
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- Auto-reload when plugins.lua changes
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Protected require and init
local status_ok, packer = pcall(require, 'packer')
if not status_ok then return end

packer.init {
	display = {
		open_fn = function() return require('packer.util').float { border = 'rounded' } end,
		-- Faster display by reducing animation time
		working_sym = '⟳',
		error_sym = '✗',
		done_sym = '✓',
		removed_sym = '-',
		moved_sym = '→',
		header_sym = '━',
		show_all_info = false,
	},
	-- Enable git cloning with depth 1 for faster installs
	git = { clone_timeout = 60, depth = 1 },
	-- Automatically clean unused plugins
	auto_clean = true,
	-- Reduce the threshold for concurrent operations
	max_jobs = 20,
}

return packer.startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Core dependencies
	use 'nvim-lua/plenary.nvim'
	use 'nvim-lua/popup.nvim'

	-- UI Components
	use {
		'kyazdani42/nvim-web-devicons',
		config = function() require('configs.devicons') end
	}

	-- Editor Enhancements
	use {
		'windwp/nvim-autopairs',
		config = function() require('configs.autopairs') end,
		event = 'InsertEnter',
	}

	use {
		'numToStr/Comment.nvim',
		config = function() require('configs.comment') end,
		keys = { 'gc', 'gb' },
	}

	-- File Explorer
	use {
		'kyazdani42/nvim-tree.lua',
		config = function() require('configs.nvim-tree') end,
	}

	-- Bufferline
	use {
		'willothy/nvim-cokeline',
		config = function() require('configs.cokeline') end,
		after = 'nvim-web-devicons',
		event = 'BufReadPost',
	}

	use 'moll/vim-bbye' -- Better buffer deletion

	-- Status Line
	use {
		'nvim-lualine/lualine.nvim',
		config = function() require('configs.lualine') end,
		after = 'nvim-web-devicons',
	}

	-- Terminal
	use { "akinsho/toggleterm.nvim", tag = '*',
		config = function() require('configs.toggleterm') end,
	}

	-- Colorschemes
	use 'EdenEast/nightfox.nvim'
	use 'savq/melange'

	-- Snippets
	use {
		'L3MON4D3/LuaSnip',
		config = function() require('configs.luasnip') end,
		requires = {
    "rafamadriz/friendly-snippets", -- Collection of pre-configured snippets (includes React)
  } }
	use { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' }

	-- Completion
	use {
		'hrsh7th/nvim-cmp',
		config = function() require('configs.cmp') end,
		requires = { 'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ'
		} }

	-- Cmp Sources
	use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
	use { 'hrsh7th/cmp-path', after = 'cmp-buffer' }
	use { 'hrsh7th/cmp-cmdline', after = 'cmp-path' }
	use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp', requires = {
		'hrsh7th/cmp-nvim-lsp',            -- For enhanced capabilities
		'Hoffs/omnisharp-extended-lsp.nvim', -- For Omnisharp
	} }
	use 'onsails/lspkind.nvim'

	-- Telescope
	use {
		'nvim-telescope/telescope.nvim',
		config = function() require('configs.telescope') end,
	}
	-- use { 'nvim-telescope/telescope-media-files.nvim', after = 'telescope.nvim' }

	-- LSP
	use {
		'neovim/nvim-lspconfig',
		config = function()
			if not package.loaded['configs.lsp'] then
				require('configs.lsp').setup()
			end
		end,
		event = 'BufReadPre',
	}

	use {
		'williamboman/mason.nvim',
		config = function()
			require('mason').setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
					}
				}
			})
		end
	}

	use {
		'williamboman/mason-lspconfig.nvim',
		after = 'mason.nvim',
		config = function()
			require('mason-lspconfig').setup({
				ensure_installed = {
					'lua_ls',
					'pyright',
					'rust_analyzer',
					'omnisharp'
				},
				automatic_installation = true
			})
		end
	}

	use {
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		after = 'mason.nvim',
		config = function() require('configs.mason-tool-installer') end,
	}

	-- Formatting
	use {
		'stevearc/conform.nvim',
		config = function() require('configs.conform') end,
	}

	-- Treesitter
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function() require('configs.treesitter') end,
		event = 'BufReadPost',
	}

	use {
		'p00f/nvim-ts-rainbow',
		after = 'nvim-treesitter',
	}

	use {
		'windwp/nvim-ts-autotag',
		after = 'nvim-treesitter',
	}

	use {
		'JoosepAlviste/nvim-ts-context-commentstring',
		after = 'nvim-treesitter',
	}

	-- Git
	use {
		'tpope/vim-fugitive',
	}

	use {
		'lewis6991/gitsigns.nvim',
		config = function() require('configs.gitsigns') end,
		event = 'BufReadPost',
	}

	-- use {
	-- 	'kdheepak/lazygit.nvim',
	-- 	config = function()
	-- 		vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>', { silent = true })
	-- 	end,
	-- }

	-- Sessions
	use {
		'folke/persistence.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('persistence').setup({
				-- Required: Set the directory to save sessions
				dir = vim.fn.stdpath('state') .. '/sessions/',
				options = { "buffers", "curdir", "tabpages", "winsize" },

				-- Exclude nvim-tree buffers
				pre_save = function(session)
					-- Remove nvim-tree buffers from the session data
					for i = #session.buffers, 1, -1 do
						if session.buffers[i].name:match("NvimTree_") then
							table.remove(session.buffers, i)
						end
					end
				end,
			})
		end,
	}

	-- EditorConfig
	use 'gpanders/editorconfig.nvim'

	-- Automatically set up your configuration after cloning packer.nvim
	if packer_bootstrap then
		require('packer').sync()
	end
end)
