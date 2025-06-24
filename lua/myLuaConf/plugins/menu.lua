-- nvzone-menu plugin configuration
-- Setup keymaps for nvzone-menu (loaded as startup plugin)

if nixCats('general.extra') then
  -- Setup keymaps for nvzone-menu
  vim.keymap.set('n', '<leader>m', function() require('menu').open('default') end, { desc = 'Open Menu' })
  vim.keymap.set('n', '<C-t>', function() require('menu').open('default') end, { desc = 'Open Default Menu' })
  vim.keymap.set({ 'n', 'v' }, '<RightMouse>', function()
    require('menu.utils').delete_old_menus()

    vim.cmd.exec('"normal! \\<RightMouse>"')

    -- clicked buf
    local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
    local options = vim.bo[buf].ft == 'neo-tree' and 'neo-tree' or 'default'

    require('menu').open(options, { mouse = true })
  end, { desc = 'Context Menu' })
end