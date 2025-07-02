-- [[ Keymaps - Terminal ]]
--
-- Exit terminal mode in the builtin terminal
-- NOTE: This won't work in all terminal emulators/tmux/etc. Can try a different
-- mapping when needed or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<leader>tn', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 10)

  vim.cmd 'normal! i'
end, { desc = '[T]erminal: [N]ew' })

--

-- Got these two funcions using this comment
-- https://www.reddit.com/r/neovim/comments/ojnl86/comment/h53t3bl/
local function oldest_terminal_id()
  local terminal_chans = {}

  for _, chan in pairs(vim.api.nvim_list_chans()) do
    if chan['mode'] == 'terminal' and chan['pty'] ~= '' then
      table.insert(terminal_chans, chan)
    end
  end

  table.sort(terminal_chans, function(left, right)
    return left['buffer'] < right['buffer']
  end)

  return terminal_chans[1]['id']
end

local function terminal_send(text)
  vim.api.nvim_chan_send(oldest_terminal_id(), text)
end

--

vim.keymap.set('n', '<leader>tl', function()
  local term_id = oldest_terminal_id()

  -- solution from this reddit post with no comments, lol
  -- https://www.reddit.com/r/neovim/comments/qjkx12/send_upcr_to_term_buffer_using_chansend_to_run/
  vim.cmd('call chansend(' .. term_id .. ', "\x1b\x5b\x41\\<cr>")')
end, { desc = '[T]erminal: Execute [L]ast Command' })

--

-- Arbitrary Commands

vim.keymap.set('n', '<leader>te', function()
  terminal_send 'echo testing\n'
end, { desc = '[T]erminal: [E]cho Test' })
