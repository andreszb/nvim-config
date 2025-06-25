local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
  colorschemeName = 'tokyonight-night'
end
vim.cmd.colorscheme(colorschemeName)

-- Setup oil plugin
require('myLuaConf.plugins.oil')

-- Setup nvzone-menu plugin
require('myLuaConf.plugins.menu')

require('lze').load({
  { import = 'myLuaConf.plugins.alpha' },
  { import = 'myLuaConf.plugins.telescope' },
  { import = 'myLuaConf.plugins.treesitter' },
  { import = 'myLuaConf.plugins.treesitter-context' },
  { import = 'myLuaConf.plugins.completion' },
  { import = 'myLuaConf.plugins.claude-code' },
  { import = 'myLuaConf.plugins.neo-tree' },
  { import = 'myLuaConf.plugins.mini' },
  { import = 'myLuaConf.plugins.markdown-preview' },
  { import = 'myLuaConf.plugins.undotree' },
  { import = 'myLuaConf.plugins.comment' },
  { import = 'myLuaConf.plugins.indent-blankline' },
  { import = 'myLuaConf.plugins.nvim-surround' },
  { import = 'myLuaConf.plugins.vim-startuptime' },
  { import = 'myLuaConf.plugins.fidget' },
  { import = 'myLuaConf.plugins.lualine' },
  { import = 'myLuaConf.plugins.gitsigns' },
  { import = 'myLuaConf.plugins.which-key' },
  { import = 'myLuaConf.plugins.toggleterm' },
  { import = 'myLuaConf.plugins.flash' },
  { import = 'myLuaConf.plugins.trouble' },
  { import = 'myLuaConf.plugins.todo-comments' },
  { import = 'myLuaConf.plugins.bufferline' },
  { import = 'myLuaConf.plugins.snacks' },
  { import = 'myLuaConf.plugins.noice' },
  { import = 'myLuaConf.plugins.yazi' },
  { import = 'myLuaConf.plugins.hardtime' },
  { import = 'myLuaConf.plugins.grug-far' },
  { import = 'myLuaConf.plugins.edgy' },
})
