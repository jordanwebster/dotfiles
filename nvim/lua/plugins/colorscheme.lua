-- One Dark, matched to the terminal.
--
-- Ghostty is on its "Atom One Dark" theme, whose background is #21252b --
-- One Dark's darker variant, not the more commonly quoted #282c34. Nvim's
-- background is pinned to that exact value below, because a near-match
-- between terminal and editor reads as a rendering fault rather than a
-- design choice.
local BACKGROUND = '#21252b'

require('onedarkpro').setup({
  colors = { bg = BACKGROUND },
})

vim.cmd.colorscheme('onedark')
