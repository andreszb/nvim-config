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
      {
        '<leader>y',
        '<cmd>Yazi<CR>',
        desc = 'Open yazi file manager',
      },
    },
    after = function()
      require('yazi').setup {
        -- Enable opening yazi for directories (needed for alpha integration)
        open_for_directories = true,
        
        -- Floating window configuration
        floating_window_scaling_factor = 0.9,
        
        -- Yazi configuration
        yazi_floating_window_winblend = 0,
        yazi_floating_window_border = 'rounded',
        
        keymaps = {
          show_help = '<f1>',
          open_file_in_vertical_split = '<c-v>',
          open_file_in_horizontal_split = '<c-x>',
          open_file_in_tab = '<c-t>',
          grep_in_directory = '<c-s>',
          replace_in_directory = '<c-g>',
          cycle_open_buffers = '<tab>',
          copy_relative_path_to_selected_files = '<c-y>',
          send_to_quickfix_list = '<c-q>',
        },
        
        -- Override default keys to enable alpha quick actions from Yazi
        set_keymappings_function = function(yazi_buffer, config, context)
          -- Default yazi keymaps
          local function map(mode, key, action, opts)
            opts = opts or { noremap = true, silent = true }
            vim.api.nvim_buf_set_keymap(yazi_buffer, mode, key, action, opts)
          end
          
          -- Alpha dashboard quick actions (same as alpha buttons)
          map('n', 'e', '<cmd>ene | startinsert<CR>', { desc = 'New file' })
          map('n', 'f', '<cmd>Telescope find_files<CR>', { desc = 'Find file' })
          map('n', 'r', '<cmd>Telescope oldfiles<CR>', { desc = 'Recent files' })
          map('n', 'g', '<cmd>Telescope live_grep<CR>', { desc = 'Find text' })
          map('n', 't', '<cmd>wincmd k<CR>', { desc = 'Focus Alpha dashboard' })
          map('n', 'o', '<cmd>Oil --float<CR>', { desc = 'Oil Browser' })
          map('n', 'c', '<cmd>e ~/.config/nvim/init.lua<CR>', { desc = 'Configuration' })
          map('n', 'q', '<cmd>qa<CR>', { desc = 'Quit' })
        end,
        
        -- Enhanced integration settings
        hooks = {
          -- When a file is opened from yazi, open it in the top window (replacing alpha)
          yazi_opened_file = function(preselected_path, command, state)
            -- If we're in the alpha + yazi layout, open file in top window
            if vim.fn.winnr('$') > 1 then
              vim.cmd('wincmd k')  -- Go to top window (alpha)
              vim.cmd('edit ' .. preselected_path)
              -- Keep focus on the opened file
            end
          end,
          
          -- When yazi closes, restore alpha if no file was opened
          yazi_closed_successfully = function(chosen_file, config, state)
            if not chosen_file and vim.fn.winnr('$') > 1 then
              -- If no file chosen and split still exists, restore alpha
              vim.cmd('wincmd k')
              vim.cmd('Alpha')
              vim.cmd('wincmd j')  -- Return to yazi window
            end
          end,
        },
      }
    end,
  },
}