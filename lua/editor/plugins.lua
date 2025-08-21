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
-- vim.cmd [[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]]

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
	-- 1. Snippet collection
	use "rafamadriz/friendly-snippets"

	-- 2. Snippet engine (must come AFTER friendly-snippets)
	-- use {
	-- 	"L3MON4D3/LuaSnip",
	-- 	run = "make install_jsregexp",
	-- 	-- commit = "v2.0.0",   -- Pinned to v2+
	-- 	-- config = function() require('configs.luasnip') end,
	-- 	tag = "v2.0.0",
	-- 	after = "friendly-snippets",
	-- }
	use {
		"L3MON4D3/LuaSnip",
		run = function()
			-- New CMake-based build (v2.2+)
			if vim.fn.executable('cmake') == 1 then
				print("Building LuaSnip jsregexp...")
				local build_cmd = [[
        cd ~/.local/share/nvim/site/pack/packer/start/LuaSnip &&
        rm -rf build &&
        mkdir -p build &&
        cd build &&
        cmake -DCMAKE_BUILD_TYPE=Release .. &&
        cmake --build .
      ]]
				os.execute(build_cmd)
			else
				print("CMake not found - LuaSnip will work with limited functionality")
			end
		end,
		tag = "v2.*",
		after = "friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load() -- Basic setup if config fails
			if pcall(require, 'configs.luasnip') then
				require('configs.luasnip')
			end
		end,
	}

	-- Completion
	-- Cmp Sources
	use {
		"hrsh7th/nvim-cmp",
		config = function() require('configs.cmp') end,
		after = "LuaSnip",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",
			"saadparwaiz1/cmp_luasnip"
		}
	}
	use { 'hrsh7th/cmp-buffer', }
	use { 'hrsh7th/cmp-path', }
	use { 'hrsh7th/cmp-cmdline', }
	use { 'hrsh7th/cmp-nvim-lsp', requires = {
		'hrsh7th/cmp-nvim-lsp',            -- For enhanced capabilities
		'Hoffs/omnisharp-extended-lsp.nvim', -- For Omnisharp
	} }
	use {
		"saadparwaiz1/cmp_luasnip",
		after = { "nvim-cmp", "LuaSnip" } -- Explicit dependency chain
	}
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
		after = 'mason-lspconfig.nvim',
		config = function()
			if not package.loaded['configs.lsp'] then
				require('configs.lsp').setup()
			end
		end,
		event = 'BufReadPre',
	}
	use 'roobert/tailwindcss-colorizer-cmp.nvim'
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
		after = "nvim-treesitter",
		config = function()
			require('nvim-ts-autotag').setup({
				filetypes = { 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue' },
			})
		end
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

	use {
		'kdheepak/lazygit.nvim',
		config = function()
			vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>', { silent = true })
		end,
	}

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
