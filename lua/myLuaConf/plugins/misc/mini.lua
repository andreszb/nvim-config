-- Mini.nvim: Collection of minimal, fast plugins
-- Modular approach to avoid duplicate plugin loading

-- Pull in modular mini configurations
local mini_modules = {
  -- Editing modules
  { module = require('myLuaConf.plugins.editing.mini-pairs'), setup = 'pairs' },
  { module = require('myLuaConf.plugins.editing.mini-ai'), setup = 'ai' },

  -- UI modules
  { module = require('myLuaConf.plugins.ui.mini-icons'), setup = 'icons' },
  { module = require('myLuaConf.plugins.ui.mini-animate'), setup = 'animate' },
}

return {
  {
    'mini.nvim',
    for_cat = 'general.always',
    event = 'DeferredUIEnter',
    after = function()
      -- Setup all mini modules
      for _, mini_config in ipairs(mini_modules) do
        mini_config.module[mini_config.setup]()
      end
    end,
  },
}

