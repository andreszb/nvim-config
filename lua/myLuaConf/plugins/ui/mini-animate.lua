-- ============================================================================
-- MINI.ANIMATE CONFIGURATION
-- ============================================================================
-- Smooth animations for scrolling and resizing
-- Features:
-- - Smooth scrolling animations
-- - Window resize animations
-- - Smart mouse scroll detection
-- - Customizable timing functions
-- ============================================================================

return {
  animate = function()
    -- Don't use animate when scrolling with the mouse
    local mouse_scrolled = false
    for _, scroll in ipairs({ 'Up', 'Down' }) do
      local key = '<ScrollWheel' .. scroll .. '>'
      vim.keymap.set({ '', 'i' }, key, function()
        mouse_scrolled = true
        return key
      end, { expr = true })
    end

    local animate = require('mini.animate')
    require('mini.animate').setup({
      resize = {
        timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),
      },
      scroll = {
        timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
        subscroll = animate.gen_subscroll.equal({
          predicate = function(total_scroll)
            if mouse_scrolled then
              mouse_scrolled = false
              return false
            end
            return total_scroll > 1
          end,
        }),
      },
    })
  end,
}