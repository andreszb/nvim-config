-- Oil plugin configuration
-- File explorer for Neovim (loaded as startup plugin)

if nixCats('general.extra') then
  vim.g.loaded_netrwPlugin = 1

  require('oil').setup({
    default_file_explorer = true,
    win_options = {
      signcolumn = 'yes:2',
    },
    view_options = {
      show_hidden = true,
    },
    columns = {
      'icon',
      'permissions',
      'size',
    },
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = 'actions.select_vsplit',
      ['<C-h>'] = 'actions.select_split',
      ['<C-t>'] = 'actions.select_tab',
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = 'actions.close',
      ['<C-l>'] = 'actions.refresh',
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = 'actions.tcd',
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },
  })

  -- Setup oil-git-status after oil is configured
  require('oil-git-status').setup({})

  vim.keymap.set('n', '-', '<cmd>Oil<CR>', { noremap = true, desc = 'Open Parent Directory' })
  vim.keymap.set('n', '<leader>-', '<cmd>Oil .<CR>', { noremap = true, desc = 'Open nvim root directory' })
end