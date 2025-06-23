local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
  colorschemeName = 'tokyonight-night'
end
vim.cmd.colorscheme(colorschemeName)

-- Note: Notifications now handled by noice.nvim instead of nvim-notify

-- Setup oil plugin immediately 
if nixCats('general.extra') then
  vim.g.loaded_netrwPlugin = 1

  require("oil").setup({
    default_file_explorer = true,
    win_options = {
      signcolumn = "yes:2",
    },
    view_options = {
      show_hidden = true
    },
    columns = {
      "icon",
      "permissions",
      "size",
    },
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
  })

  -- Setup oil-git-status after oil is configured
  require("oil-git-status").setup({})

  vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, desc = 'Open Parent Directory' })
  vim.keymap.set("n", "<leader>-", "<cmd>Oil .<CR>", { noremap = true, desc = 'Open nvim root directory' })
end

require('lze').load {
  { import = "myLuaConf.plugins.alpha", },
  { import = "myLuaConf.plugins.telescope", },
  { import = "myLuaConf.plugins.treesitter", },
  { import = "myLuaConf.plugins.treesitter-context", },
  { import = "myLuaConf.plugins.completion", },
  { import = "myLuaConf.plugins.claude-code", },
  { import = "myLuaConf.plugins.neo-tree", },
  { import = "myLuaConf.plugins.mini", },
  { import = "myLuaConf.plugins.markdown-preview", },
  { import = "myLuaConf.plugins.undotree", },
  { import = "myLuaConf.plugins.comment", },
  { import = "myLuaConf.plugins.indent-blankline", },
  { import = "myLuaConf.plugins.nvim-surround", },
  { import = "myLuaConf.plugins.vim-startuptime", },
  { import = "myLuaConf.plugins.fidget", },
  { import = "myLuaConf.plugins.lualine", },
  { import = "myLuaConf.plugins.gitsigns", },
  { import = "myLuaConf.plugins.which-key", },
  { import = "myLuaConf.plugins.toggleterm", },
  { import = "myLuaConf.plugins.flash", },
  { import = "myLuaConf.plugins.trouble", },
  { import = "myLuaConf.plugins.todo-comments", },
  { import = "myLuaConf.plugins.bufferline", },
  { import = "myLuaConf.plugins.snacks", },
  { import = "myLuaConf.plugins.noice", },
}
