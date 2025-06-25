return {
  {
    'multicursor.nvim',
    for_cat = 'general.extra',
    event = 'DeferredUIEnter',
    after = function()
      require('multicursor-nvim').setup()
      
      local map = vim.keymap.set
      
      -- Add cursors above/below
      map({ 'n', 'v' }, '<C-Up>', function()
        require('multicursor-nvim').lineAddCursor(-1)
      end, { desc = 'Add cursor above' })
      
      map({ 'n', 'v' }, '<C-Down>', function()
        require('multicursor-nvim').lineAddCursor(1)
      end, { desc = 'Add cursor below' })
      
      -- Match word under cursor
      map({ 'n', 'v' }, '<C-n>', function()
        require('multicursor-nvim').matchAddCursor(1)
      end, { desc = 'Add cursor at next match' })
      
      map({ 'n', 'v' }, '<C-s>', function()
        require('multicursor-nvim').matchSkipCursor(1)
      end, { desc = 'Skip match and add next' })
      
      -- Add all matches
      map({ 'n', 'v' }, '<leader>A', function()
        require('multicursor-nvim').matchAllAddCursors()
      end, { desc = 'Add cursors at all matches' })
      
      -- Clear cursors
      map('n', '<Esc>', function()
        if require('multicursor-nvim').cursorsEnabled() then
          require('multicursor-nvim').clearCursors()
        else
          vim.cmd('noh')
        end
      end, { desc = 'Clear cursors or search highlight' })
    end,
  },
}