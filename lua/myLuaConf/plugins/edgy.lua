return {
  {
    'edgy.nvim',
    for_cat = 'general.extra',
    event = 'DeferredUIEnter',
    keys = {
      {
        '<leader>ue',
        function()
          require('edgy').toggle()
        end,
        desc = 'Toggle Edgy',
      },
      {
        '<C-e>',
        function()
          local edgy = require('edgy')
          local is_open = false
          
          -- Check if left panel is currently open
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'neo-tree' then
              local config = vim.api.nvim_win_get_config(win)
              if config.relative == '' then -- Not a floating window
                is_open = true
                break
              end
            end
          end
          
          if not is_open then
            -- Open all three neo-tree sources when opening left panel
            vim.cmd('Neotree show position=left filesystem')
            vim.cmd('Neotree position=left source=git_status')
            vim.cmd('Neotree position=left source=buffers')
          else
            -- Close the left panel
            edgy.toggle('left')
          end
          
          -- Focus the filesystem neo-tree window after opening
          if not is_open then
            vim.schedule(function()
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == 'neo-tree' and vim.b[buf].neo_tree_source == 'filesystem' then
                  local config = vim.api.nvim_win_get_config(win)
                  if config.relative == '' then -- Not a floating window
                    vim.api.nvim_set_current_win(win)
                    break
                  end
                end
              end
            end)
          end
        end,
        desc = 'Toggle Left Panel',
      },
      {
        '<leader>ur',
        function()
          local edgy = require('edgy')
          edgy.toggle('right')
          -- Focus the right panel after opening
          vim.schedule(function()
            -- Find grug-far or undotree window in right position
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.bo[buf].filetype
              if ft == 'grug-far' or ft == 'undotree' then
                local config = vim.api.nvim_win_get_config(win)
                if config.relative == '' then -- Not a floating window
                  vim.api.nvim_set_current_win(win)
                  break
                end
              end
            end
          end)
        end,
        desc = 'Toggle Right Panel',
      },
      {
        '<leader>ub',
        function()
          local edgy = require('edgy')
          edgy.toggle('bottom')
          -- Focus the bottom panel after opening
          vim.schedule(function()
            -- Find trouble, qf, or help window in bottom position
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.bo[buf].filetype
              if ft == 'trouble' or ft == 'qf' or ft == 'help' or ft == 'noice' then
                local config = vim.api.nvim_win_get_config(win)
                if config.relative == '' then -- Not a floating window
                  vim.api.nvim_set_current_win(win)
                  break
                end
              end
            end
          end)
        end,
        desc = 'Toggle Bottom Panel',
      },
    },
    after = function()
      require('edgy').setup {
        -- Animation options
        animate = {
          enabled = true,
          fps = 200, -- Doubled from 100
          cps = 240, -- Doubled from 120
        },

        -- Exit behavior
        exit_when_last = false,  -- Keep edgy windows open, show dashboard instead
        close_when_all_hidden = true,
        
        -- Prevent edgy from managing main editor area
        main = {
          -- Don't let edgy manage the main editing area
          edgebar = false,
        },

        -- Global options
        options = {
          left = { size = 30 },
          bottom = { size = 10 },
          right = { size = 40 },
          top = { size = 0 }, -- No top panel, bufferline handles top area
        },
        
        -- Integration with other plugins
        wo = {
          -- Window options for edgy windows
          winhl = 'Normal:EdgyNormal',
        },
        
        -- Prevent edgy from managing specific filetypes in main area
        exclude = {
          ft = {}, -- Don't exclude any filetypes from main editing area
          bt = {}, -- Don't exclude any buffer types
        },

        -- Left sidebar configuration
        left = {
          {
            title = 'Neo-Tree Filesystem',
            ft = 'neo-tree',
            filter = function(buf)
              return vim.b[buf].neo_tree_source == 'filesystem'
            end,
            pinned = true,
            open = function()
              vim.cmd('Neotree show position=left filesystem')
            end,
          },
          {
            title = 'Neo-Tree Git Status',
            ft = 'neo-tree',
            filter = function(buf)
              return vim.b[buf].neo_tree_source == 'git_status'
            end,
            pinned = true,
            open = function()
              vim.cmd('Neotree show position=left git_status')
            end,
          },
          {
            title = 'Neo-Tree Buffers',
            ft = 'neo-tree',
            filter = function(buf)
              return vim.b[buf].neo_tree_source == 'buffers'
            end,
            pinned = true,
            open = function()
              vim.cmd('Neotree show position=left buffers')
            end,
          },
        },

        -- Right sidebar configuration
        right = {
          {
            title = 'Search and Replace',
            ft = 'grug-far',
            pinned = true,
            open = function()
              require('grug-far').open()
            end,
          },
          {
            title = 'Undotree',
            ft = 'undotree',
            pinned = true,
            open = 'UndotreeToggle',
          },
        },

        -- Bottom panel configuration
        bottom = {
          {
            title = 'Trouble',
            ft = 'trouble',
            pinned = true,
            open = function()
              require('trouble').toggle()
            end,
            filter = function(buf, win)
              return vim.w[win].trouble
                and vim.w[win].trouble.position == 'bottom'
                and vim.w[win].trouble.type == 'split'
                and vim.w[win].trouble.relative == 'editor'
                and not vim.w[win].trouble_preview
            end,
          },
          {
            title = 'QuickFix',
            ft = 'qf',
            pinned = true,
            open = 'copen',
          },
          {
            title = 'Location List', 
            ft = 'qf',
            pinned = true,
            open = 'lopen',
          },
          {
            title = 'Help',
            ft = 'help',
            pinned = true,
            size = { height = 20 },
            filter = function(buf)
              return vim.bo[buf].buftype == 'help'
            end,
          },
        },

        -- Top panel configuration
        top = {
          -- Reserved for bufferline (managed externally)
        },

        -- Key mappings
        keys = {
          -- Increase width
          ['<c-Right>'] = function(win) win:resize('width', 2) end,
          -- Decrease width  
          ['<c-Left>'] = function(win) win:resize('width', -2) end,
          -- Increase height
          ['<c-Up>'] = function(win) win:resize('height', 2) end,
          -- Decrease height
          ['<c-Down>'] = function(win) win:resize('height', -2) end,
        },

        -- Icons
        icons = {
          closed = ' ',
          open = ' ',
        },

        -- Fix for some filetypes
        fix = {
          -- Fix trouble buffers
          ['trouble'] = {
            pinned = true,
            open = function()
              require('trouble').toggle()
            end,
          },
          -- Fix grug-far buffers
          ['grug-far'] = {
            pinned = true,
            open = function()
              require('grug-far').open()
            end,
          },
        },
      }
    end,
  },
}
