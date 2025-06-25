-- ============================================================================
-- SNACKS WORDS CONFIGURATION
-- ============================================================================
-- Word highlighting like VSCode's symbol highlighting
-- Features:
-- - Highlights all instances of word under cursor
-- - Debounced highlighting (200ms delay)
-- - Works in normal, insert, and command modes
-- - Smart fold opening when jumping
-- - Jumplist integration for navigation
-- 
-- Key mappings:
-- (Automatic on cursor movement - no manual mappings)
-- (Note: <leader>uw mapping commented out in snacks.lua)
-- ============================================================================

return {
  -- Word highlighting (like VSCode's symbol highlighting)
  words = {
    enabled = true,
    debounce = 200,
    notify_jump = false,
    notify_end = true,
    foldopen = true,
    jumplist = true,
    modes = { 'n', 'i', 'c' },
  },
}