-- yazi.nvim: the file manager, in a floating window.
--
-- Chosen over a sidebar tree because the question being asked of it is
-- "where am I, and what is around me" rather than "show me the whole
-- project". yazi is a miller-column browser: it opens on the current file
-- with its directory listed, and moving up adds a parent column to the left,
-- so the path is visible without any other directory being expanded.
--
-- The yazi binary does the work; this is a thin wrapper around it, which is
-- why it is worth having when yazi is already installed and configured.

require('yazi').setup({
  -- netrw still owns `:Edit .` and directory arguments. Left alone: taking
  -- those over is a bigger behavioural change than this keymap needs.
  open_for_directories = false,
  keymaps = { show_help = '<f1>' },
})

-- `-` to go up to the containing directory, the convention vim-vinegar
-- established and oil.nvim kept. It shadows the builtin `-` motion (first
-- non-blank of the previous line), which is a fair trade for the key that
-- best describes "up".
vim.keymap.set('n', '-', '<cmd>Yazi<cr>', { desc = 'File manager (at current file)' })
vim.keymap.set('n', '<leader>-', '<cmd>Yazi cwd<cr>', { desc = 'File manager (at cwd)' })
