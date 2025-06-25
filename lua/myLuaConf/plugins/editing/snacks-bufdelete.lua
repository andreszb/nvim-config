-- ============================================================================
-- SNACKS BUFDELETE CONFIGURATION
-- ============================================================================
-- Smart buffer deletion that preserves window layouts
-- Features: 
-- - Closes buffer without affecting window layout
-- - Handles special buffers gracefully
-- - Supports deleting other buffers
-- 
-- Key mappings:
-- <leader>bd - Delete current buffer
-- <leader>bo - Delete all other buffers
-- ============================================================================

return {
  -- Smart buffer deletion with layout preservation
  bufdelete = { enabled = true },
}