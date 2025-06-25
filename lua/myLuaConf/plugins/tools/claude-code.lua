return {
  {
    "claude-code.nvim",
    for_cat = 'general.extra',
    event = "DeferredUIEnter",
    after = function(plugin)
      require('claude-code').setup()
    end,
  },
}
