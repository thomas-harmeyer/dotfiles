local packer = require('packer')

packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- package manager
  use 'nvim-lua/plenary.nvim' -- lua utils
  use 'nvim-lualine/lualine.nvim' -- statusline
  use 'neovim/nvim-lspconfig' -- neovim lsp
  use 'folke/tokyonight.nvim' -- colorscheme
  use 'folke/which-key.nvim' -- key mapper
  use {'nvim-telescope/telescope.nvim', tag = '0.1.0'} -- telescope
  use "nvim-telescope/telescope-file-browser.nvim" -- telescope file browser extension
  use 'kyazdani42/nvim-web-devicons' -- icons
  use {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    requires = {
      { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
      {
        'ms-jpq/coq.thirdparty',
        branch = '3p',
        config = function()
          require 'coq_3p' { { src = 'copilot', short_name = 'COP', accept_key = '<c-f>' } }
        end,
      },
    },
    config = function()
      vim.g.coq_settings = {
        auto_start = true,
        clients = {
          tree_sitter = { enabled = false },
          paths = { enabled = true, resolution = { 'file' } },
          snippets = { enabled = true, warn = {} },
          tags = { enabled = false },
        },
        keymap = { recommended = false },
        display = {
          preview = { positions = { north = 4, south = nil, west = 2, east = 3 } },
        },
      }
    end,
  }
  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
end)
