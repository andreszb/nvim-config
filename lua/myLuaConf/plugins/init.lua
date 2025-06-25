local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
  colorschemeName = 'tokyonight-night'
end
vim.cmd.colorscheme(colorschemeName)

-- Setup oil plugin
require('myLuaConf.plugins.navigation.oil')

-- Setup nvzone-menu plugin
require('myLuaConf.plugins.misc.menu')

require('lze').load({
  -- UI plugins
  { import = 'myLuaConf.plugins.ui.alpha' },
  { import = 'myLuaConf.plugins.ui.bufferline' },
  { import = 'myLuaConf.plugins.ui.lualine' },
  { import = 'myLuaConf.plugins.ui.noice' },
  { import = 'myLuaConf.plugins.ui.indent-blankline' },
  { import = 'myLuaConf.plugins.ui.edgy' },
  
  -- Navigation plugins
  { import = 'myLuaConf.plugins.navigation.telescope' },
  { import = 'myLuaConf.plugins.navigation.neo-tree' },
  { import = 'myLuaConf.plugins.navigation.yazi' },
  { import = 'myLuaConf.plugins.navigation.flash' },
  
  -- Editing plugins
  { import = 'myLuaConf.plugins.editing.completion' },
  { import = 'myLuaConf.plugins.editing.multicursor' },
  { import = 'myLuaConf.plugins.editing.nvim-surround' },
  { import = 'myLuaConf.plugins.editing.comment' },
  { import = 'myLuaConf.plugins.editing.undotree' },
  { import = 'myLuaConf.plugins.editing.grug-far' },
  
  -- Language plugins
  { import = 'myLuaConf.plugins.language.treesitter' },
  { import = 'myLuaConf.plugins.language.treesitter-context' },
  { import = 'myLuaConf.plugins.language.markdown-preview' },
  
  -- Git plugins
  { import = 'myLuaConf.plugins.git.gitsigns' },
  
  -- Tools plugins
  { import = 'myLuaConf.plugins.tools.toggleterm' },
  { import = 'myLuaConf.plugins.tools.trouble' },
  { import = 'myLuaConf.plugins.tools.todo-comments' },
  { import = 'myLuaConf.plugins.tools.fidget' },
  { import = 'myLuaConf.plugins.tools.which-key' },
  { import = 'myLuaConf.plugins.tools.vim-startuptime' },
  { import = 'myLuaConf.plugins.tools.hardtime' },
  { import = 'myLuaConf.plugins.tools.claude-code' },
  
  -- Misc plugins
  { import = 'myLuaConf.plugins.misc.mini' },
  { import = 'myLuaConf.plugins.misc.snacks' },
})
