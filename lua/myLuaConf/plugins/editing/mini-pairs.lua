-- ============================================================================
-- MINI.PAIRS CONFIGURATION
-- ============================================================================
-- Automatic bracket/quote pairing
-- Features:
-- - Auto-pairing of brackets, quotes, etc.
-- - Smart handling of existing pairs
-- - Customizable pair characters
-- ============================================================================

return {
  pairs = function()
    require('mini.pairs').setup()
  end,
}