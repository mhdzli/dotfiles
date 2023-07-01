local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

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

-- Single border style for prompt popups.
packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
})

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use {
    "wbthomason/packer.nvim", -- Have packer manage itself
    opt = false
  }

  use "sbdchd/neoformat"
  use "tpope/vim-fugitive"
  use "mzlogin/vim-markdown-toc"
  use "nvim-lualine/lualine.nvim"
  use "simrat39/symbols-outline.nvim"

  -- Colorschemes
  use {
    "sainnhe/sonokai",
    "folke/tokyonight.nvim",
    "LunarVim/Colorschemes",
    "navarasu/onedark.nvim",
  }

  -- Colorizer
  use "norcalli/nvim-colorizer.lua"

  use "mbbill/undotree"
  use "windwp/nvim-autopairs"
  use "numToStr/Comment.nvim"

  -- LSP & cmp
  use {
    "neovim/nvim-lspconfig",
    "onsails/lspkind-nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "glepnir/lspsaga.nvim",
    -- "hrsh7th/cmp-vsnip",
    -- "hrsh7th/vim-vsnip",
    "simrat39/rust-tools.nvim"
  }
  -- use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}

  use {
    "williamboman/mason-lspconfig.nvim",
    "williamboman/mason.nvim",
    run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }

  use {
    "rafamadriz/friendly-snippets",
    branch = "main",
  }

  use "https://git.sr.ht/~whynothugo/lsp_lines.nvim"

  use {
    "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
    "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
    {
      "nvim-telescope/telescope.nvim",
      requires = { {'nvim-lua/plenary.nvim'} },
    },
    "nvim-telescope/telescope-fzy-native.nvim",
  }

  -- Treesitter
  use {
    {
      "nvim-treesitter/nvim-treesitter",
      run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    },
    "nvim-treesitter/playground",
    "nvim-treesitter/nvim-treesitter-context",
  }

  use {
    "vimwiki/vimwiki",
    config = function()
      vim.g.vimwiki_list = {
        {
          path = '~/.local/share/disroot/Notes',
          syntax = 'markdown',
          ext = '.md',
        }
      }
      vim.g.vimwiki_ext2syntax = {
        ['.md'] = 'markdown',
        ['.markdown'] = 'markdown',
        ['.mdown'] = 'markdown',
        ['.Rmd'] = 'markdown',
        ['.rmd'] = 'markdown',
      }
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
