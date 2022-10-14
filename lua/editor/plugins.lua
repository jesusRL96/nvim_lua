local fn = vim.fn
-- Automatically install packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end


-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of pluginsuse
  use {"windwp/nvim-autopairs", config = function() require'configs.autopairs' end} -- Autopairs, integrates with both cmp and treesitter
  use {"numToStr/Comment.nvim", config = function() require'configs.comment' end} -- Easily comment stuff
  use 'kyazdani42/nvim-web-devicons'
  use {"kyazdani42/nvim-tree.lua", config = function() require'configs.nvim-tree' end}
  use {"akinsho/bufferline.nvim", config = function() require'configs.bufferline' end}
  use "moll/vim-bbye"
  use {'nvim-lualine/lualine.nvim', config = function() require'configs.lualine' end}
  use {"akinsho/toggleterm.nvim", config = function() require'configs.toggleterm' end}

  -- colorschemes
  use {"EdenEast/nightfox.nvim"}

  -- snippets
  use {"L3MON4D3/LuaSnip"} --snippet engine
  use {"rafamadriz/friendly-snippets"} -- a bunch of snippets to use

  -- cmp plugins
  use {"hrsh7th/nvim-cmp", } -- The completion plugin
  use {"hrsh7th/cmp-buffer", after = 'nvim-cmp'} -- buffer completions
  use {"hrsh7th/cmp-path", after = 'cmp-buffer'} -- path completions
  use {"hrsh7th/cmp-cmdline", after = 'cmp-path'} -- cmdline completions
  use {"saadparwaiz1/cmp_luasnip", after = 'cmp-cmdline'} -- snippet completions
  use {"hrsh7th/cmp-nvim-lsp", after = 'cmp_luasnip', config = function() require'configs.cmp' end}

  -- LSP
  use {"williamboman/mason.nvim"}
  use {"WhoIsSethDaniel/mason-tool-installer.nvim"}
  use {"jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim" },} -- for formatters and linters
  use {"neovim/nvim-lspconfig"} -- enable LSP
  use {"williamboman/mason-lspconfig.nvim", after = "mason.nvim" , config = function() require"configs.lsp" end}
  -- use {"jayp0521/mason-null-ls.nvim", after = { "mason.nvim", "null-ls.nvim" }}
  --use {"jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim" },config = function() require"configs.null-ls" end,} -- for formatters and linters
  --[[ use {"MunifTanjim/prettier.nvim", config = function() require"configs.prettier" end,} ]]
  -- use {"jayp0521/mason-null-ls.nvim", after = { "mason.nvim", "null-ls.nvim}
  -- use {"jayp0521/mason-null-ls.nvim", after = { "mason.nvim", "null-ls.nvim" }, config = function() require"configs.null-ls" end,}
    
  -- Telescope
  use {"nvim-telescope/telescope.nvim"}
  use {'nvim-telescope/telescope-media-files.nvim', after = 'telescope.nvim', config = function() require'configs.telescope' end}

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function() require'configs.treesitter' end
  }
  use "p00f/nvim-ts-rainbow"
  use "nvim-treesitter/playground"
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  
  -- Git
  use "tpope/vim-fugitive"
  use {"lewis6991/gitsigns.nvim", after = 'vim-fugitive', config = function() require'configs.gitsigns' end}

  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
