-- Autocommands.

local group = vim.api.nvim_create_augroup('dotfiles', { clear = true })

-- Check whether the file changed on disk, and reload it if so.
--
-- 'autoread' (config/options.lua) only takes effect when Nvim gets around to
-- checking; these are the moments that mean "another process may have written
-- this file while you were elsewhere". Restricted to normal mode in a real
-- file buffer so a reload never lands mid-edit or inside a prompt.
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'TermClose', 'TermLeave' }, {
  group = group,
  callback = function()
    if vim.bo.buftype == '' and vim.api.nvim_get_mode().mode == 'n' then
      vim.cmd('checktime')
    end
  end,
})

-- Say when that happened, rather than letting the buffer change under you.
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = group,
  callback = function()
    vim.notify('Reloaded: file changed on disk', vim.log.levels.WARN)
  end,
})

-- Flash what was just yanked, so the extent of the operation is visible.
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reopen a file where you left it.
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
