return {
  { -- Autoformat
    -- Using this to run formatting on <leader>f
    -- To see all formatters:
    -- :help conform-formatters
    --
    -- Original format on save configuration:
    -- format_on_save = function(bufnr)
    --   -- Disable "format_on_save lsp_fallback" for languages that don't
    --   -- have a well standardized coding style. You can add additional
    --   -- languages here or re-enable it for the disabled ones.
    --   -- local disable_filetypes = { c = true, cpp = true }
    --   local disable_filetypes = {}
    --   if disable_filetypes[vim.bo[bufnr].filetype] then
    --     return nil
    --   else
    --     return {
    --       timeout_ms = 500,
    --       lsp_format = 'fallback',
    --     }
    --   end
    -- end,
    --
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        --
        rust = { 'rustfmt' },
        --
        cpp = { 'clang-format' },
        c = { 'clang-format' },
        --
        markdown = { 'mdformat' },
        --
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
      },
      formatters = {
        mdformat = {
          prepend_args = { '--wrap=80' },
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
