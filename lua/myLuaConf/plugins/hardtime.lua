-- Hardtime.nvim: Break bad Vim habits by restricting repetitive key usage
-- Enable/Disable: :Hardtime enable | :Hardtime disable | :Hardtime toggle
return {
  {
    'hardtime.nvim',
    for_cat = 'general.extra',
    event = 'DeferredUIEnter',
    after = function()
      require('hardtime').setup {
        timeout = 5000,
        disable_mouse = false, -- Enable mouse usage
        -- Add yazi to disabled filetypes (not in default)
        disabled_filetypes = {
          ['yazi'] = true,
        },
      }
    end,
  },
}
