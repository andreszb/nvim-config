return {
  {
    'nvim-treesitter-context',
    for_cat = 'general.treesitter',
    event = 'DeferredUIEnter',
    after = function()
      require('treesitter-context').setup({
        mode = 'topline',
      })
    end,
  },
}
