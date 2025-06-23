return {
  {
    'flash.nvim',
    for_cat = 'general.extra',
    keys = {
      { "/", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "?", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
    after = function()
      require('flash').setup({})
    end,
  },
}