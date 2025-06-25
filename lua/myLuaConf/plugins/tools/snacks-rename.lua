-- ============================================================================
-- SNACKS RENAME CONFIGURATION
-- ============================================================================
-- File and buffer renaming with LSP integration
-- Features:
-- - Smart file renaming with LSP symbol updates
-- - Buffer name synchronization
-- - Handles imports and references automatically
-- - Works with version control systems
-- 
-- Key mappings:
-- <leader>cR - Rename current file with LSP integration
-- ============================================================================

return {
  -- File/buffer renaming with LSP integration
  rename = { enabled = true },
}