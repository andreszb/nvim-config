return {
  {
    "ts-comments.nvim",
    for_cat = 'general.extra',
    event = "DeferredUIEnter",
    after = function()
      require('ts-comments').setup()
    end,
  },
}