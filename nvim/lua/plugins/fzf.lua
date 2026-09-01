-- fzf-lua: fuzzy finding, grep, and the LSP and git pickers.
--
-- Wraps the fzf binary instead of sorting in Lua, and shells out to fd and
-- ripgrep for file and text search.

local fzf = require('fzf-lua')

fzf.setup({
  -- Take colours from the active colorscheme rather than fzf's own palette.
  fzf_colors = true,
})

local map = vim.keymap.set

-- Finding, all under the <leader>f prefix.
map('n', '<leader>ff', fzf.files, { desc = 'Find files' })
map('n', '<leader>fg', fzf.live_grep, { desc = 'Grep (live)' })
map('n', '<leader>fb', fzf.buffers, { desc = 'Buffers' })
map('n', '<leader>fh', fzf.helptags, { desc = 'Help tags' })

map('n', '<leader>fw', fzf.grep_cword, { desc = 'Grep word under cursor' })
map('n', '<leader>fr', fzf.resume, { desc = 'Resume last picker' })
map('n', '<leader>fd', fzf.diagnostics_workspace, { desc = 'Diagnostics' })
map('n', '<leader>fs', fzf.lsp_document_symbols, { desc = 'Symbols (this file)' })
map('n', '<leader>fS', fzf.lsp_live_workspace_symbols, { desc = 'Symbols (workspace)' })

-- Git, for reviewing a changeset rather than a single file.
--
-- gitsigns (plugins/git.lua) answers "what changed in this buffer" and owns
-- the buffer-local <leader>g maps; these answer "what changed across the
-- repo". git_hunks puts every hunk in the working tree into a single
-- fuzzy-searchable list.
map('n', '<leader>gs', fzf.git_status, { desc = 'Git status (changed files)' })
map('n', '<leader>gh', fzf.git_hunks, { desc = 'Git hunks (whole changeset)' })
map('n', '<leader>gc', fzf.git_commits, { desc = 'Git commits (repo)' })
map('n', '<leader>gf', fzf.git_bcommits, { desc = 'Git commits (this file)' })

-- Search every type in the project.
--
-- Distinct from `grt`, which jumps to the type of the symbol already under the
-- cursor. This is the "I know there is a type called something like Foo"
-- search. fzf-lua's regex_filter takes a predicate; symbol kind is on the item
-- for document symbols and only in the rendered text for workspace ones, so
-- both are checked.
local TYPE_KINDS = {
  Class = true,
  Struct = true,
  Interface = true,
  Enum = true,
  TypeParameter = true,
}

map('n', '<leader>ft', function()
  fzf.lsp_live_workspace_symbols({
    regex_filter = function(item)
      local kind = item.kind or (item.text and item.text:match('%[(.-)%]'))
      return kind ~= nil and TYPE_KINDS[kind] == true
    end,
  })
end, { desc = 'Find types (workspace)' })
