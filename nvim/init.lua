-- Neovim configuration.
--
-- Requires Nvim 0.12 or newer. This config leans on things that only exist
-- from 0.12: the built-in plugin manager (vim.pack), built-in insert-mode
-- completion ('autocomplete'), and the default LSP keymaps. There is
-- deliberately no plugin-manager bootstrap block, because there no longer
-- needs to be one.
--
--   lua/config/    options, keymaps, autocmds, language servers
--   lua/plugins/   one file per plugin: its setup and its keymaps together
--
-- Plugin versions are pinned in nvim-pack-lock.json, which is committed.
-- Update everything with :lua vim.pack.update()

-- Must be set before anything defines a <leader> mapping.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- The treesitter `main` branch pins parser versions to the plugin, so a plugin
-- update without a matching :TSUpdate leaves parsers and queries mismatched.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name ~= 'nvim-treesitter' then
      return
    end
    if ev.data.kind == 'install' or ev.data.kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.pack.add({
  -- Parsers and queries. `main` is a full rewrite requiring 0.12; `master` is
  -- the frozen old plugin, so the branch is pinned rather than left to drift.
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  -- Installed for its data, not its API: it ships lsp/<name>.lua files that
  -- give Nvim's own vim.lsp.enable() the cmd and root markers per server.
  'https://github.com/neovim/nvim-lspconfig',

  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/seblyng/roslyn.nvim',
  'https://github.com/olimorris/onedarkpro.nvim',

  -- yazi.nvim, and the one dependency it declares. lazy.nvim would install
  -- that transitively; vim.pack does not, so it is listed explicitly.
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/mikavilpas/yazi.nvim',
}, {
  -- Running install.sh, or starting Nvim after editing this list, is already
  -- the intent to install. A prompt here only blocks the first start on a new
  -- machine, where nothing is installed yet and every answer would be "yes".
  confirm = false,
})

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.lsp')

require('plugins.treesitter')
require('plugins.fzf')
require('plugins.git')
require('plugins.format')
require('plugins.whichkey')
require('plugins.roslyn')
require('plugins.colorscheme')
require('plugins.yazi')
