-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights and close floating windows
vim.keymap.set('n', '<Esc>', function()
  -- Clear highlights on search when pressing <Esc> in normal mode
  -- See `:help hlsearch`
  vim.cmd 'nohlsearch'

  -- Close any floating windows
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == 'win' then
      vim.api.nvim_win_close(win, false)
    end
  end
end)

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<,aei> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-,>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-i>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-a>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-e>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Replacing Text ]]
--
vim.keymap.set('n', '<leader>rw', [["_diwP]], { desc = '[R]eplace [W]ord under cursor with last op' })

vim.keymap.set('n', '<leader>rl', function()
  -- figure out if the unnamed register is linewise (V) or not
  local rtype = vim.fn.getregtype('"'):sub(1, 1)
  if rtype == 'V' then
    --  linewise register
    vim.cmd 'normal! "_ddP'
  else
    -- for charwise or block, need to feed real <C-r>" and <Esc>
    -- build the keystroke sequence:
    local cr_dqt = vim.api.nvim_replace_termcodes('<C-r>"', true, false, true)
    local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
    -- and prepend the black-hole change‐line command:
    local seq = '"_cc' .. cr_dqt .. esc
    vim.api.nvim_feedkeys(seq, 'n', false)
  end
end, { desc = '[R]eplace current [L]ine with last op' })

vim.keymap.set(
  'n',
  '<leader>rs',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]],
  { desc = '[R]eplace with [S]ubstitution' }
)

-- vim: ts=2 sts=2 sw=2 et
