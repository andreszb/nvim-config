-- Snacks.nvim: Collection of small, useful utilities by folke
-- Complements existing setup with lightweight conveniences

-- Pull in modular snacks configurations
local snacks_modules = {
  -- UI modules
  require('myLuaConf.plugins.ui.snacks-statuscolumn'),
  require('myLuaConf.plugins.ui.snacks-words'),

  -- Editing modules
  require('myLuaConf.plugins.editing.snacks-bufdelete'),
  require('myLuaConf.plugins.editing.snacks-scratch'),

  -- Git modules
  require('myLuaConf.plugins.git.snacks-gitbrowse'),
  require('myLuaConf.plugins.git.snacks-lazygit'),

  -- Tool modules
  require('myLuaConf.plugins.tools.snacks-rename'),
  require('myLuaConf.plugins.tools.snacks-toggle'),
  require('myLuaConf.plugins.tools.snacks-win'),
  require('myLuaConf.plugins.tools.snacks-debug'),

  -- Misc modules
  require('myLuaConf.plugins.misc.snacks-quickfile'),
  require('myLuaConf.plugins.misc.snacks-bigfile'),
  require('myLuaConf.plugins.misc.snacks-styles'),
}

-- Merge all modular configurations
local snacks_config = {}
for _, module in ipairs(snacks_modules) do
  for k, v in pairs(module) do
    snacks_config[k] = v
  end
end

return {
  {
    'snacks.nvim',
    for_cat = 'general.extra',
    priority = 1000, -- Load early since many features are foundational

    -- Key mappings for snacks utilities
    keys = {
      -- Terminal management
      -- { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },

      { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse' },

      -- Buffer management
      { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
      { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete Other Buffers' },
      { '<S-j>', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },

      -- File operations
      { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
      { '<leader>S', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },

      -- Words highlighting (like VSCode)
      -- { '<leader>uw', function() Snacks.words.toggle() end, desc = 'Toggle Word Highlighting' },

      -- Window management
      -- { '<leader>wz', function() Snacks.win.zoom() end, desc = 'Zoom Window' },

      -- Quick actions
      { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File' },
      { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History' },
    },

    after = function() require('snacks').setup(snacks_config) end,
  },
}

