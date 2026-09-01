-- Options.
--
-- Only settings Nvim does not already default to; anything core now gets
-- right is left alone.

local o = vim.o

-- Four spaces, never tabs.
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.number = true
o.relativenumber = true
o.cursorline = true
o.wrap = false
o.colorcolumn = '80'
o.scrolloff = 8

-- Always reserve the sign column, so text does not shift sideways the moment
-- a diagnostic or a git sign appears.
o.signcolumn = 'yes'

-- Undo that survives closing the file; no swap or backup litter. The default
-- undo directory under stdpath('state') is where it should be, so it is not
-- overridden.
o.undofile = true
o.swapfile = false
o.backup = false

-- Highlight search matches. Leaving matches lit is not a problem because Nvim
-- maps <C-l> to clear them.
o.hlsearch = true
o.ignorecase = true
o.smartcase = true
o.inccommand = 'split'

o.splitright = true
o.splitbelow = true

-- Built-in insert-mode completion, new in 0.12. This is what replaces
-- nvim-cmp and its six source plugins; see config/lsp.lua for the LSP half.
o.autocomplete = true
o.completeopt = 'menu,menuone,popup,noselect,fuzzy'

-- Reload files that changed on disk.
--
-- Files here are frequently rewritten by other tools while a buffer is open.
-- Without this, each such change becomes a "file changed" prompt, or is
-- silently overwritten by the next :w. config/autocmds.lua forces the check;
-- 'autoread' on its own only acts when Nvim happens to look.
o.autoread = true

-- Drives CursorHold, which the checktime autocmd above hangs off.
o.updatetime = 250

-- Ask about unsaved changes instead of refusing to quit.
o.confirm = true

o.mouse = 'a'
o.termguicolors = true

