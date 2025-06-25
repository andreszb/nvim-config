-- ============================================================================
-- SNACKS STYLES CONFIGURATION
-- ============================================================================
-- Floating window styles for snacks components
-- Features:
-- - Notification window styling
-- - Terminal window styling  
-- - LazyGit window styling
-- - Consistent window appearance across snacks features
-- ============================================================================

return {
  styles = {
    notification = {
      wo = { wrap = true },
      bo = { filetype = 'snacks_notif' },
    },
    terminal = {
      bo = { filetype = 'snacks_terminal' },
      wo = {},
    },
    lazygit = {
      bo = { filetype = 'snacks_lazygit' },
      wo = { colorcolumn = '' },
    },
  },
}