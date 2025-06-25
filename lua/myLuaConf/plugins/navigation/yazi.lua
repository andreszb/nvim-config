return {
  {
    'yazi.nvim',
    for_cat = 'general.extra',
    keys = {
      {
        '<leader>-',
        '<cmd>Yazi<CR>',
        desc = 'Open yazi at the current file',
      },
      {
        '<leader>cw',
        '<cmd>Yazi cwd<CR>',
        desc = 'Open yazi at the current working directory',
      },
    },
    after = function()
      require('yazi').setup {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = false,
        keymaps = {
          show_help = '<f1>',
        },
      }
    end,
  },
}