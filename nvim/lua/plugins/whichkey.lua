-- which-key: shows what can follow a prefix, once one has been started.
--
-- In a bigger config this would be noise. It is here for the opposite reason:
-- this config is edited rarely, so the <leader>f maps are exactly the kind of
-- thing that gets forgotten between uses.

require('which-key').setup({
  delay = 400,
})

require('which-key').add({
  { '<leader>f', group = 'find' },
  { '<leader>g', group = 'git' },
})
