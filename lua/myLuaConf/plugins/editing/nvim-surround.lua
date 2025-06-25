return {
  {
    "nvim-surround",
    for_cat = 'general.always',
    event = "DeferredUIEnter",
    after = function(plugin)
      require('nvim-surround').setup()
    end,
  },
}