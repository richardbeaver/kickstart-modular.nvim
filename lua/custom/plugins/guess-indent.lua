return {
  -- Auto detect indentation and apply to file settings
  -- Using for C++ files:
  --    - File is formatted using .clang-format settings in project root
  --    - Reload the current C++ buffer if needed for this plugin to modify tab
  --      and shift settings based on that formatting
  'NMAC427/guess-indent.nvim',
  opts = {},
}
