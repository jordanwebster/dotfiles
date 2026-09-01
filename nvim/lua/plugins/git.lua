-- gitsigns: which lines changed, in the sign column.
--
-- Earns a place in a deliberately small plugin set because agents write most
-- of the code in this setup: the gutter is where reviewing someone else's
-- edit starts.

require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- ]c and [c are what Vim already uses to move between diff hunks, so they
    -- keep their meaning inside a real :diffsplit and gain it everywhere else.
    map(']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gs.nav_hunk('next')
      end
    end, 'Next git hunk')

    map('[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gs.nav_hunk('prev')
      end
    end, 'Previous git hunk')

    map('<leader>gp', gs.preview_hunk, 'Preview hunk')
    map('<leader>gb', function() gs.blame_line({ full = true }) end, 'Blame line')
    map('<leader>gd', gs.diffthis, 'Diff this file')
  end,
})
