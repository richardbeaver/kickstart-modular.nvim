-- Diagnostic Config
-- See :help vim.diagnostic.Opts
--

-- Default virtual text config
local virtual_text_config = {
  source = 'if_many',
  spacing = 2,
  format = function(diagnostic)
    local diagnostic_message = {
      [vim.diagnostic.severity.ERROR] = diagnostic.message,
      [vim.diagnostic.severity.WARN] = diagnostic.message,
      [vim.diagnostic.severity.INFO] = diagnostic.message,
      [vim.diagnostic.severity.HINT] = diagnostic.message,
    }
    return diagnostic_message[diagnostic.severity]
  end,
}

-- Set configuration
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  -- underline = { severity = vim.diagnostic.severity.ERROR },
  underline = true,
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = virtual_text_config,
}

-- Diagnostic keymaps
--
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = '[D]iagnostics - Open [Float]' })

--

local diagnostics_virtual_text_enabled = true

vim.keymap.set('n', '<leader>td', function()
  diagnostics_virtual_text_enabled = not diagnostics_virtual_text_enabled
  vim.diagnostic.config {
    virtual_text = diagnostics_virtual_text_enabled and virtual_text_config or false,
  }
end, { desc = 'Diagnostics: [T]oggle [D]iagnostic virtual text' })

--

vim.keymap.set('n', '<leader>dc', function()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })
  if #diags == 0 then
    print 'No diagnostics on this line.'
    return
  end
  local msgs = vim.tbl_map(function(d)
    return d.message
  end, diags)
  local combined = table.concat(msgs, '\n')
  vim.fn.setreg('+', combined)
  print 'Copied all diagnostics on this line.'
end, { desc = '[D]iagnostics - [C]opy all diagnostics on this line' })
