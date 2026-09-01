-- Treesitter: syntax-aware highlighting.
--
-- This is the `main` branch, a full rewrite that requires Nvim 0.12 and is
-- effectively a different plugin from the old `master`. There is no
-- configs.setup(); parsers are installed explicitly, and highlighting is
-- started by Nvim per buffer rather than by the plugin.

-- Nvim ships parsers for c, lua, markdown, query and vim. These are the rest.
require('nvim-treesitter').install({
  'bash', 'c_sharp', 'css', 'diff', 'dockerfile', 'git_config', 'gitcommit',
  'go', 'gomod', 'gosum', 'html', 'javascript', 'json', 'python',
  'regex', 'rust', 'toml', 'tsx', 'typescript', 'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('dotfiles-treesitter', { clear = true }),
  callback = function(ev)
    -- Filetypes with no installed parser are the normal case, not an error:
    -- start() raises for them, so a failure here is simply "no treesitter for
    -- this buffer" and the buffer keeps its regex syntax highlighting.
    pcall(vim.treesitter.start, ev.buf)
  end,
})
