-- ============================================================================
-- SNACKS LAZYGIT CONFIGURATION
-- ============================================================================
-- LazyGit integration with floating window interface
-- Features:
-- - Full-screen LazyGit in floating window (90% size)
-- - File history for current buffer
-- - Custom window styling
-- - Seamless integration with Neovim
-- 
-- Key mappings:
-- <leader>gf - Open LazyGit file history for current file
-- (Note: <leader>gg disabled in favor of other git tools)
-- ============================================================================

return {
  -- LazyGit integration with floating window
  lazygit = {
    enabled = true,
    win = {
      style = 'lazygit',
      width = 0.9,
      height = 0.9,
    },
  },
}