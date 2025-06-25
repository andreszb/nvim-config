-- ============================================================================
-- SNACKS SCRATCH CONFIGURATION
-- ============================================================================
-- Scratch buffer management for quick notes and temporary content
-- Features:
-- - Auto-detects filetype (defaults to markdown for empty buffers)
-- - Persistent scratch buffers
-- - Multiple scratch buffer support
-- - Smart buffer naming
-- 
-- Key mappings:
-- <leader>.  - Toggle scratch buffer
-- <leader>S  - Select from multiple scratch buffers
-- ============================================================================

return {
  -- Scratch buffer management for quick notes
  scratch = {
    enabled = true,
    name = 'scratch',
    ft = function()
      if vim.bo.buftype == '' and vim.bo.filetype == '' then
        return 'markdown'
      end
      return vim.bo.filetype
    end,
  },
}