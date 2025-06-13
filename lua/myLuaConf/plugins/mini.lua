return {
  {
    'mini.nvim',
    for_cat = 'general.always',
    event = "DeferredUIEnter",
    after = function (plugin)
      require('mini.pairs').setup()
      require('mini.icons').setup()
      require('mini.ai').setup()
    end,
  },
}