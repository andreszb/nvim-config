-- ============================================================================
-- SNACKS BIGFILE CONFIGURATION
-- ============================================================================
-- Performance optimization for large files
-- Features:
-- - Disables heavy features for files larger than 1.5MB
-- - Turns off syntax highlighting, word highlighting, folding, and spell check
-- - Improves performance when working with large files
-- ============================================================================

return {
  bigfile = {
    enabled = true,
    -- Disable features for files larger than 1.5MB
    size = 1.5 * 1024 * 1024,
    setup = function()
      vim.cmd('syntax off')
      vim.cmd('IlluminatePauseBuf') -- Disable word highlighting
      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.spell = false
    end,
  },
}