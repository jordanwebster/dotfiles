-- Options.
--
-- Carried over from the 2023 init.vim, minus everything Nvim has since made
-- the default (hidden, incsearch, smartindent, noerrorbells, ttimeout).

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
-- undo directory (stdpath('state')) is correct now, so unlike the 2023 config
-- there is nothing to point it at.
o.undofile = true
o.swapfile = false
o.backup = false

-- Highlight search matches. The 2023 config set 'nohlsearch' to avoid matches
-- staying lit; that is unnecessary because Nvim maps <C-l> to clear them.
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
-- The single most important setting here for how this editor is actually
-- used: coding agents rewrite files underneath open buffers. Without it every
-- agent edit becomes a "file changed" prompt, or worse, gets silently
-- overwritten by the next :w. See config/autocmds.lua, which forces the check
-- -- 'autoread' on its own only acts when Nvim happens to look.
o.autoread = true

-- Drives CursorHold, which the checktime autocmd above hangs off.
o.updatetime = 250

-- Ask about unsaved changes instead of refusing to quit.
o.confirm = true

o.mouse = 'a'
o.termguicolors = true

