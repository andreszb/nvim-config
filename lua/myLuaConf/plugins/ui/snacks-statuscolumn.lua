-- ============================================================================
-- SNACKS STATUSCOLUMN CONFIGURATION
-- ============================================================================
-- Enhanced status column with git integration
-- Features:
-- - Marks and signs on the left
-- - Fold and git info on the right
-- - Git highlighting for folds
-- - Integration with GitSign and MiniDiffSign
-- ============================================================================

return {
  statuscolumn = {
    enabled = true,
    left = { 'mark', 'sign' },
    right = { 'fold', 'git' },
    folds = {
      open = true,
      git_hl = true,
    },
    git = {
      patterns = { 'GitSign', 'MiniDiffSign' },
    },
  },
}